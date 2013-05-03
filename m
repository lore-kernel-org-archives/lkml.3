Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955Ab3ECJXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:23:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34275 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3ECJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:23:14 -0400
Date: Fri, 3 May 2013 11:23:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-pm@vger.kernel.org,
        "'Len Brown'" <len.brown@intel.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Message-ID: <20130503092311.GA13832@amd.pavel.ucw.cz>
References: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com>
 <1474315.q4folvZv3e@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474315.q4folvZv3e@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> > to be assigned without having an #define xxx NULL for the case that PM is
> > not enabled.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> I've queued this up as v3.11 material.

> > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
> >  }
> >  #endif
> >  
> > -#ifdef CONFIG_PM
> >  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> >  #ifdef CONFIG_PM_SLEEP
> >  	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
> > @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> >  #endif
> >  };
> >  
> > -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> > -#else
> > -#define S3C24XX_DEV_PM_OPS NULL
> > -#endif
> > -
> >  /* device driver for platform bus bits */

Will not this enlarge .data by sizeof(struct dev_pm_ops)?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
