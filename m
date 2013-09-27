Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3I0IRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:17:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:54700 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3I0IRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:17:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,991,1371106800"; 
   d="scan'208";a="384303478"
Date: Fri, 27 Sep 2013 11:22:59 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: define i2c_dw_pci_runtime_idle only with
 runtime pm
Message-ID: <20130927082259.GC28875@intel.com>
References: <1380234243-23787-1-git-send-email-vincent.stehle@laposte.net>
 <20130927024313.GB3159@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130927024313.GB3159@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 04:43:13AM +0200, Wolfram Sang wrote:
> On Fri, Sep 27, 2013 at 12:24:03AM +0200, Vincent Stehlé wrote:
> > Make sure i2c_dw_pci_runtime_idle() is defined only when actually used, when
> > CONFIG_PM_RUNTIME is defined.
> > 
> > This fixes the following compilation warning:
> > 
> >  drivers/i2c/busses/i2c-designware-pcidrv.c:188:12: warning: ‘i2c_dw_pci_runtime_idle’ defined but not used [-Wunused-function]
> > 
> > Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> > Cc: Wolfram Sang <wsa@the-dreams.de>
> 
> I wonder if this fix is complete? Mika?
> 
> > ---
> >  drivers/i2c/busses/i2c-designware-pcidrv.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > index f6ed06c..2b5d3a6 100644
> > --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > @@ -185,6 +185,7 @@ static int i2c_dw_pci_resume(struct device *dev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM_RUNTIME
> >  static int i2c_dw_pci_runtime_idle(struct device *dev)
> >  {
> >  	int err = pm_schedule_suspend(dev, 500);
> > @@ -194,6 +195,7 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
> >  		return 0;
> >  	return -EBUSY;
> >  }
> > +#endif
> >  
> >  static const struct dev_pm_ops i2c_dw_pm_ops = {
> 
> Shouldn't this be using UNIVERSAL_DEV_PM_OPS with the suspend and resume
> function #ifdeffed by CONFIG_PM_SLEEP?

Yes, I think that would be better.

> 
> >  	.resume         = i2c_dw_pci_resume,
> > -- 
> > 1.8.4.rc3
> > 


