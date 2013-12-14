Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3LNUYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:24:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38256 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3LNUYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:24:54 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:24:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steve Wise <swise@chelsio.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] drivers: infiniband: Mark function _c4iw_write_mem_dma()
 as static in mem.c
Message-ID: <20131214202444.GB17601@leaf>
References: <20131214131214.GA8459@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214131214.GA8459@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:42:14PM +0530, Rashika Kheria wrote:
> This patch marks the function _c4iw_write_mem_dma() as static in
> hw/cxgb4/mem.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in hw/cxgb4/mem.c:
> drivers/infiniband/hw/cxgb4/mem.c:176:5: warning: no previous prototype for ‘_c4iw_write_mem_dma’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/infiniband/hw/cxgb4/mem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
> index 4cb8eb2..84e4500 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -173,7 +173,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
>  	return ret;
>  }
>  
> -int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len, void *data)
> +static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len, void *data)
>  {
>  	u32 remain = len;
>  	u32 dmalen;
> -- 
> 1.7.9.5
> 
