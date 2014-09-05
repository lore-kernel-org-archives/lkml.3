Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaIESZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:25:38 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36873 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaIESZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:25:36 -0400
Date: Fri, 5 Sep 2014 19:25:31 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Lee Jones <lee.jones@linaro.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: Re: [STLinux Kernel] [PATCH 4/4] watchdog: st_wdt: Add new driver
 for ST's LPC Watchdog
Message-ID: <20140905182531.GA2383@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409841592-18890-1-git-send-email-lee.jones@linaro.org>
 <1409841592-18890-6-git-send-email-lee.jones@linaro.org>
 <20140905155811.GA12374@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905155811.GA12374@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > +static int st_wdog_remove(struct platform_device *pdev)
> > +{
> > +	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
> > +
> > +	if (watchdog_active(&st_wdog_dev))
> > +		st_wdog_stop(&st_wdog_dev);
> > +
> > +	st_wdog_setup(st_wdog, WDT_DISABLE);
> > +
> > +	watchdog_unregister_device(&st_wdog_dev);
> > +
> No clk_disable_unprepare ?
> 
> Maye it is not necessary, but then I wonder why you have it above.

I think your right it should have a clk_disable_unprepare. Otherwise you will end up leaking a clock
reference each time you insmod / rmmod the driver.
> 
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int st_wdog_suspend(struct device *dev)
> > +{
> > +	if (watchdog_active(&st_wdog_dev))
> > +		st_wdog_stop(&st_wdog_dev);
> > +
> 
> Is any clock activity necessary here ? Just asking, I don't really have an idea.

I would also expect the clock to be managed in suspend / resume callbacks.

regards,

Peter.
