Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab3HSGuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:50:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:44005 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3HSGt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,911,1367996400"; 
   d="scan'208";a="348204654"
Date: Mon, 19 Aug 2013 11:36:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Felipe Balbi <balbi@ti.com>, Randy Dunlap <rdunlap@infradead.org>,
        Roger Quadros <rogerq@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] dma: cpp41: make it compile with CONFIG_BUG=n
Message-ID: <20130819060620.GV32147@intel.com>
References: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au>
 <520D0AD7.6050002@infradead.org>
 <520E0304.5050906@ti.com>
 <20130816154055.GB3570@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816154055.GB3570@breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:40:55PM +0200, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Before Randy figures out that this does not compile with CONFIG_BUG=n
> here is a fix for it.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vinod Koul <vinod.koul@intel.com>

~Vinod
> ---
>  drivers/dma/cppi41.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> index 5dcebca..e696178 100644
> --- a/drivers/dma/cppi41.c
> +++ b/drivers/dma/cppi41.c
> @@ -579,7 +579,7 @@ static int cppi41_tear_down_chan(struct cppi41_channel *c)
>  				WARN_ON(!c->is_tx && !(pd0 & TD_DESC_IS_RX));
>  				WARN_ON((pd0 & 0x1f) != c->port_num);
>  			} else {
> -				__WARN();
> +				WARN_ON_ONCE(1);
>  			}
>  			c->td_seen = 1;
>  		}
> -- 
> 1.8.4.rc2
> 

-- 
