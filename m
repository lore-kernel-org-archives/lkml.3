Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEUGVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:21:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:30249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaEUGV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:21:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="515251736"
Date: Wed, 21 May 2014 11:35:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dmaengine: sa11x0: remove broken #ifdef
Message-ID: <20140521060548.GM21128@intel.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-2-git-send-email-arnd@arndb.de>
 <1399565317.9018.4.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399565317.9018.4.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:38:37PM +0530, Shevchenko, Andriy wrote:
> On Thu, 2014-05-08 at 16:56 +0200, Arnd Bergmann wrote:
> > The sa11x0_dma_pm_ops unconditionally reference sa11x0_dma_resume
> > and sa11x0_dma_suspend, which currently breaks if CONFIG_PM_SLEEP
> > is disabled.
> > 
> > There is probably a better way to remove the reference in this
> > case, but the safe choice is to have the suspend/resume code always
> > built in the driver.
> 
> Maybe you could create a macro in pm.h for *_noirq version of
> suspend/resume? However, like we discussed with Vinod it's much better
> to use suspend_late/resume_early for DMAC device drivers, though I have
> no idea if it works for sa11x0.
It should work as the guidance is not client/controller specfic. But I think
thats not the point here as the fix is not related to how suspend is
implemented..

-- 
~Vinod

> 
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: dmaengine@vger.kernel.org
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/dma/sa11x0-dma.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
> > index ab26d46..5ebdfbc 100644
> > --- a/drivers/dma/sa11x0-dma.c
> > +++ b/drivers/dma/sa11x0-dma.c
> > @@ -113,11 +113,9 @@ struct sa11x0_dma_phy {
> >  	struct sa11x0_dma_desc	*txd_load;
> >  	unsigned		sg_done;
> >  	struct sa11x0_dma_desc	*txd_done;
> > -#ifdef CONFIG_PM_SLEEP
> >  	u32			dbs[2];
> >  	u32			dbt[2];
> >  	u32			dcsr;
> > -#endif
> >  };
> >  
> >  struct sa11x0_dma_dev {
> > @@ -984,7 +982,6 @@ static int sa11x0_dma_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > -#ifdef CONFIG_PM_SLEEP
> >  static int sa11x0_dma_suspend(struct device *dev)
> >  {
> >  	struct sa11x0_dma_dev *d = dev_get_drvdata(dev);
> > @@ -1054,7 +1051,6 @@ static int sa11x0_dma_resume(struct device *dev)
> >  
> >  	return 0;
> >  }
> > -#endif
> >  
> >  static const struct dev_pm_ops sa11x0_dma_pm_ops = {
> >  	.suspend_noirq = sa11x0_dma_suspend,
> 
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@intel.com>
> Intel Finland Oy

-- 
