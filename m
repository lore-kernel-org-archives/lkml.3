Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaD1T5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:57:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28071 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933054AbaD1Tx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:28 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 00/10] Versatile Express changes for 3.16
Date: Mon, 28 Apr 2014 18:57:47 +0100
Message-Id: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

What follows is the (hopefully) last take on the vexpress
infrastructure changes. With the exception of the first
patch, everything else has been discussed and acked
(or at least not naked) in the past:

http://thread.gmane.org/gmane.linux.kernel/1645586/
http://thread.gmane.org/gmane.linux.kernel/1619575/

I'd like to see it merged in the 3.16, so if there are
no major issues, I'll send a pull request next week.

The series, based on 3.15-rc3, is available at:

  git://git.linaro.org/people/pawel.moll/linux.git vexpress/sysreg

Pawel Moll (9):
  of: Keep track of populated platform devices
  mfd: vexpress: Convert custom func API to regmap
  mfd: syscon: Add platform data with a regmap config name
  mfd: vexpress: Define the device as MFD cells
  clk: versatile: Split config options for sp810 and vexpress_osc
  clocksource: Sched clock source for Versatile Express
  ARM: vexpress: Simplify SMP operations for DT-powered system
  ARM: vexpress: move HBI check to sysreg driver
  hwmon: vexpress: Use devm helper for hwmon device registration

Sudeep KarkadaNagesha (1):
  ARM: vexpress: remove redundant vexpress_dt_cpus_num to get cpu count

 .../devicetree/bindings/arm/vexpress-sysreg.txt    |  79 ++-
 Documentation/devicetree/bindings/arm/vexpress.txt |  15 +-
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |   5 +-
 arch/arm/mach-vexpress/core.h                      |   3 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |  10 +-
 arch/arm/mach-vexpress/platsmp.c                   | 187 ++-----
 arch/arm/mach-vexpress/v2m.c                       |  82 +--
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi       |   2 +-
 drivers/bus/Kconfig                                |   9 +
 drivers/bus/Makefile                               |   2 +
 drivers/bus/vexpress-config.c                      | 202 ++++++++
 drivers/clk/Kconfig                                |   9 +-
 drivers/clk/versatile/Kconfig                      |  26 +
 drivers/clk/versatile/Makefile                     |   5 +-
 drivers/clk/versatile/clk-vexpress-osc.c           |  94 ++--
 drivers/clocksource/Kconfig                        |  11 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/versatile.c                    |  40 ++
 drivers/hwmon/vexpress.c                           | 104 ++--
 drivers/mfd/Kconfig                                |  15 +-
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/syscon.c                               |   4 +
 drivers/mfd/vexpress-config.c                      | 287 -----------
 drivers/mfd/vexpress-sysreg.c                      | 554 ++++++---------------
 drivers/misc/Kconfig                               |   9 +
 drivers/misc/Makefile                              |   1 +
 drivers/misc/vexpress-syscfg.c                     | 324 ++++++++++++
 drivers/of/platform.c                              |  10 +-
 drivers/power/reset/vexpress-poweroff.c            |  16 +-
 drivers/regulator/vexpress.c                       |  50 +-
 include/linux/of.h                                 |   1 +
 include/linux/platform_data/syscon.h               |   8 +
 include/linux/vexpress.h                           |  94 +---
 35 files changed, 1209 insertions(+), 1204 deletions(-)
 create mode 100644 drivers/bus/vexpress-config.c
 create mode 100644 drivers/clk/versatile/Kconfig
 create mode 100644 drivers/clocksource/versatile.c
 delete mode 100644 drivers/mfd/vexpress-config.c
 create mode 100644 drivers/misc/vexpress-syscfg.c
 create mode 100644 include/linux/platform_data/syscon.h

-- 
1.9.1

