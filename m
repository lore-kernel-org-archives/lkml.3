Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3LJQF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:05:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53507 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3LJQFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:05:53 -0500
Date: Tue, 10 Dec 2013 17:05:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
Message-ID: <20131210160548.GC18888@pengutronix.de>
References: <1384913711.13115.2.camel@phoenix>
 <20131210132431.GB18888@pengutronix.de>
 <52A71746.6080809@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52A71746.6080809@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Tue, Dec 10, 2013 at 02:29:42PM +0100, Daniel Lezcano wrote:
> On 12/10/2013 02:24 PM, Uwe Kleine-König wrote:
> >On Wed, Nov 20, 2013 at 10:15:11AM +0800, Axel Lin wrote:
> >>The time-efm32 driver uses the clocksource MMIO functions.
> >>Thus it needs to select CLKSRC_MMIO in Kconfig.
> >>
> >>Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >>---
> >>This fixes build error when COMPILE_TEST=y.
> >>drivers/built-in.o: In function `efm32_clocksource_init':
> >>drivers/clocksource/time-efm32.c:162: undefined reference to `clocksource_mmio_init'
> >>drivers/built-in.o: In function `efm32_timer_init':
> >>drivers/clocksource/time-efm32.c:274: undefined reference to `clocksource_mmio_readl_up'
> >>make: *** [vmlinux] Error 1
> >>
> >>  drivers/clocksource/Kconfig | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >>diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> >>index bdb953e..99763eb 100644
> >>--- a/drivers/clocksource/Kconfig
> >>+++ b/drivers/clocksource/Kconfig
> >>@@ -75,6 +75,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
> >>  config CLKSRC_EFM32
> >>  	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
> >>  	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
> >>+	select CLKSRC_MMIO
> >>  	default ARCH_EFM32
> >I'd like to send support for arch/arm/mach-efm32 for 3.14. Formerly I
> >had ARCH_EFM32 select CLKSRC_MMIO, but having it here is obviously the
> >correct thing to do. So my possibilities are:
> >
> >  a) I take this patch and apply mach-efm32 on top of it; or
> >  b) you take it early enough for me into 3.13-rc to base mach-efm32 on
> >     it; or
> 
> I sent the PR with this patch. If everything is ok, it should be in
> the next -rc.
ok. Thanks for your quick reply.

It would be great if your tree were included in linux-next. Don't you
think this is feasible?

Best regards
Uwe
 
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
