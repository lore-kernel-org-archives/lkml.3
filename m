Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3IZH7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:59:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41734 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3IZH7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:59:01 -0400
Date: Thu, 26 Sep 2013 09:58:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
Message-ID: <20130926075855.GH16106@pengutronix.de>
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <5242F434.7060702@linaro.org>
 <20130925153207.GG16106@pengutronix.de>
 <524376A0.7020405@linaro.org>
 <524377E3.4050806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <524377E3.4050806@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:55:15PM -0700, John Stultz wrote:
> On 09/25/2013 04:49 PM, Daniel Lezcano wrote:
> > On 09/25/2013 05:32 PM, Uwe Kleine-König wrote:
> >> Hello Daniel,
> >>
> >> On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
> >>> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
> >>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> >>>> index 41c6946..410b152 100644
> >>>> --- a/drivers/clocksource/Kconfig
> >>>> +++ b/drivers/clocksource/Kconfig
> >>>> @@ -70,6 +70,14 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
> >>>>  	help
> >>>>  	  Use the always on PRCMU Timer as sched_clock
> >>>>  
> >>>> +config CLKSRC_EFM32
> >>>> +	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
> >>>> +	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
> >>>> +	default ARCH_EFM32
> >>>> +	help
> >>>> +	  Support to use the timers of EFM32 SoCs as clock source and clock
> >>>> +	  event device.
> >>>> +
> >>> No option for the timer. It must be selected by the platform.
> >> It is. If ARCH_EFM32=y there is no prompt and the "default ARCH_EFM32"
> >> makes it true.
> > ok, with that but if ARCH_EFM32=no, you can enable it manually. AFAIK,
> > we want to prevent this and let the correct arch to enable it.
> >
> > John ?
> 
> Right until there's really a compelling reason (which I've still not
> heard), I don't want to introduce independent clocksource options. Any
> such options should be something like a platform or board config option.
You can only manually enable it if you also enabled COMPILE_TEST. Then
the intention is clear, isn't it?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
