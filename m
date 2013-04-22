Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3DVKUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:20:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:23261 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3DVKUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:20:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289692607"
Date: Mon, 22 Apr 2013 15:18:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 21/32] dmaengine: ste_dma40: Also report the number of
 logical channels
Message-ID: <20130422094842.GL24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
 <20130422093631.GE24632@intel.com>
 <20130422101455.GH3432@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422101455.GH3432@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:14:55AM +0100, Lee Jones wrote:
> On Mon, 22 Apr 2013, Vinod Koul wrote:
> 
> > On Thu, Apr 18, 2013 at 11:12:03AM +0100, Lee Jones wrote:
> > > Now we know the total of physical and logical channels, we may as
> > > well report them within the information log.
> > > 
> > > Before:
> > > dma40 dma40.0: hardware revision: 3 @ 0x801c0000 with 8 physical channels
> > > 
> > > After:
> > > <as above ...> and 256 logical channels
> > > 
> > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > Cc: Dan Williams <djbw@fb.com>
> > > Cc: Per Forlin <per.forlin@stericsson.com>
> > > Cc: Rabin Vincent <rabin@rab.in>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/dma/ste_dma40.c |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> > > index 282dd59..805049c 100644
> > > --- a/drivers/dma/ste_dma40.c
> > > +++ b/drivers/dma/ste_dma40.c
> > > @@ -3200,8 +3200,9 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
> > >  
> > >  	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
> > >  
> > > -	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
> > > -		 rev, res->start, num_phy_chans);
> > > +	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
> > > +		"%d physical channels and %d logical channels\n",
> > > +		rev, res->start, num_phy_chans, num_log_chans);
> > Splitting log messages across lines is bad idea and sacrifces readablity... also
> > wasnt splitting logging to multiple lines emit checkpatch warn
> 
> You also get a check-patch error if your lines are over 80 chars.
No, you get a warn
> 
> How would you solve this?
Use common sense :) I would never sacrfice readablity of code. Erring on 80chars
is fine by me as long as it makes sense.

--
~Vinod
