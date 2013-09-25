Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3IYQNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:13:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38942 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754292Ab3IYQNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:13:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/5] Allwinner SoCs High Speed Timer support
Date: Wed, 25 Sep 2013 17:03:05 +0300
Message-Id: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here is a few patches adding support for the High Speed Timers running on the
Allwinner SoCs.

These timers are 64 bits timers running at a much higher speed than the timers
used for now on these SoCs, since they are no longer wired to the 24MHz
oscillator, but to the AHB clock.

This HS timers are actually found in all the supported SoCs but the A10.
However, the A20 and A31 come with 4 of these high speed timers, while the A10s
and A13 only have two, hence why we introduce two different compatibles.

The A31 is not using these for now, as its timers are asserted in reset by a
reset controller that first need to gain some support in the kernel first, but
that's for another patchset.

Thanks,
Maxime

Maxime Ripard (5):
  clocksource: sun4i: Select CLKSRC_MMIO
  clocksource: Add Allwinner SoCs HS timers driver
  ARM: sun5i: a10s: Add support for the High Speed Timers
  ARM: sun5i: a13: Add support for the High Speed Timers
  ARM: sun7i: a20: Add support for the High Speed Timers

 .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |  22 +++
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   7 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   7 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  10 ++
 arch/arm/mach-sunxi/Kconfig                        |   1 +
 drivers/clocksource/Kconfig                        |   5 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/timer-sun5i.c                  | 189 +++++++++++++++++++++
 8 files changed, 242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
 create mode 100644 drivers/clocksource/timer-sun5i.c

-- 
1.8.4

