Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbbALPhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:37:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54875 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbbALPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:37:07 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 0/8] Atmel System Timer cleanups
Date: Mon, 12 Jan 2015 16:36:55 +0100
Message-Id: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets cleans up the system timer driver.

The main goal is to get rid of the mach/ headers dependency. At the same time,
it introduces proper probing and locking (using a regmap) for the watchdog
driver.

Changes in v3:
 - moved the watchdog regmap_st allocation after the multiple probe check
 - check whether regmap_st is NULL in the watchdog driver

Changes in v2:
 - cleaned up more includes in the watchdog driver
 - stop using if OF when selecting CLKSRC_OF
 - stop initializing .owner


Alexandre Belloni (8):
  ARM: at91/dt: declare atmel,at91rm9200-st as a syscon
  mfd: Add atmel-st driver
  watchdog: at91rm9200: use the regmap from mfd
  ARM: at91: time: move the system timer driver to drivers/clocksource
  ARM: at91: move the restart function to the system timer driver
  clocksource: atmel-st: properly initialize driver
  clocksource: atmel-st: use syscon/regmap
  ARM: at91: remove useless include

 .../devicetree/bindings/arm/atmel-at91.txt         |   2 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |   2 +-
 arch/arm/mach-at91/Makefile                        |   2 +-
 arch/arm/mach-at91/at91rm9200.c                    |  11 ---
 arch/arm/mach-at91/board-dt-rm9200.c               |   7 --
 arch/arm/mach-at91/generic.h                       |   3 -
 drivers/clocksource/Kconfig                        |   4 +
 drivers/clocksource/Makefile                       |   1 +
 .../clocksource/timer-atmel-st.c                   | 109 +++++++++------------
 drivers/mfd/Kconfig                                |   7 ++
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/atmel-st.c                             |  77 +++++++++++++++
 drivers/watchdog/Kconfig                           |   2 +-
 drivers/watchdog/at91rm9200_wdt.c                  |  25 +++--
 .../mach/at91_st.h => include/linux/mfd/atmel-st.h |  20 +---
 15 files changed, 158 insertions(+), 115 deletions(-)
 rename arch/arm/mach-at91/at91rm9200_time.c => drivers/clocksource/timer-atmel-st.c (74%)
 create mode 100644 drivers/mfd/atmel-st.c
 rename arch/arm/mach-at91/include/mach/at91_st.h => include/linux/mfd/atmel-st.h (84%)

-- 
2.1.0

