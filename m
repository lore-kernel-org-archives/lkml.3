Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3E3Npd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:45:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54891 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab3E3Np2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:45:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        linux-pm@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Thu, 30 May 2013 15:54:20 +0200
Message-ID: <4119506.fLP8mVnrTk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130530105644.GA3595@katana>
References: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com> <20130503092311.GA13832@amd.pavel.ucw.cz> <20130530105644.GA3595@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 12:56:45 PM Wolfram Sang wrote:
> On Fri, May 03, 2013 at 11:23:11AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> > > > to be assigned without having an #define xxx NULL for the case that PM is
> > > > not enabled.
> > > > 
> > > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > 
> > > I've queued this up as v3.11 material.
> > 
> > > > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > > > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > > > @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
> > > >  }
> > > >  #endif
> > > >  
> > > > -#ifdef CONFIG_PM
> > > >  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> > > >  #ifdef CONFIG_PM_SLEEP
> > > >  	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
> > > > @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> > > >  #endif
> > > >  };
> > > >  
> > > > -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> > > > -#else
> > > > -#define S3C24XX_DEV_PM_OPS NULL
> > > > -#endif
> > > > -
> > > >  /* device driver for platform bus bits */
> > 
> > Will not this enlarge .data by sizeof(struct dev_pm_ops)?
> 
> Same question here. Is it the preferred way now to use this new macro
> although having the cost of having an empty dev_pm_ops?

No, it isn't, but if someone wants to use it, I don't really care that much.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
