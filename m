Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3KTXN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:13:56 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:33595 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3KTXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:13:53 -0500
Message-ID: <528D4232.3020708@linaro.org>
Date: Thu, 21 Nov 2013 00:13:54 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PULL] : clockevents/clocksource fixes for 3.12
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

this pull request is an update of the previous one, refreshed against 
the latest timers/urgent.

  * Stephen Boyd hidden the event stream Kconfig option for the 
arch_arm_timer for non ARM architectures

  * Laurent Pinchard fixed a missing a clk_put in case the registering 
of the sh_mtu[2] drivers fails.

  * Uwe Kleine-König reuse clockevents_config_and_register for the 
at91rm9200_time timer as it was depending on the patch (commit a4578ea 
(clockevents: Sanitize ticks to nsec conversion)

The following changes since commit 050ded1bbaea3331745cf2782315f5bc2582d083:

   tick: Document tick_do_timer_cpu (2013-11-19 14:59:50 +0100)

are available in the git repository at:

   git://git.linaro.org/people/dlezcano/linux.git clockevents/fixes

for you to fetch changes up to 77f7ce9a9f636daaa65731a833bae1311a7b80e5:

   clocksource: arm_arch_timer: Hide eventstream Kconfig on non-ARM 
(2013-11-21 00:06:52 +0100)

----------------------------------------------------------------
Laurent Pinchart (4):
       clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
       clocksource: sh_mtu2: Add clk_prepare/unprepare support
       clocksource: sh_tmu: Release clock when sh_tmu_register() fails
       clocksource: sh_tmu: Add clk_prepare/unprepare support

Stephen Boyd (1):
       clocksource: arm_arch_timer: Hide eventstream Kconfig on non-ARM

Uwe Kleine-König (1):
       ARM: at91: rm9200: switch back to clockevents_config_and_register

  arch/arm/mach-at91/at91rm9200_time.c |    7 ++-----
  drivers/clocksource/Kconfig          |    1 +
  drivers/clocksource/sh_mtu2.c        |   16 ++++++++++++++--
  drivers/clocksource/sh_tmu.c         |   20 +++++++++++++++++---
  4 files changed, 34 insertions(+), 10 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

