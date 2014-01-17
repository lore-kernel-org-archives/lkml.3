Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaAQTTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:19:46 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39942 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaAQTTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:19:42 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v4 0/8] ARM: brcmstb: Add Broadcom STB SoC support
Date: Fri, 17 Jan 2014 11:19:19 -0800
Message-Id: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the board support package for the
Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
minimal set of code needed for a BCM7445-based board to boot
the Linux kernel.

These changes heavily leverage the OF/devicetree framework.

v4:
- make a reboot driver and put it in the drivers folder
- rework DT bindings to leverage 'syscon'
- rework BSP code to use 'syscon' for all register mappings
- misc. tweaks per suggestions from v3

v3:
- rebased to v3.13-rc8
- switched to using 'multi_v7_defconfig'
- eliminated dependence on compile-time peripheral register access
- moved DT node iomap out from 'init_early'
- misc. minor cleanups from mailing-list discussion for v2

v2:
- rebased to v3.13-rc1
- moved implementation to 'mach-bcm' folder
- added CPU init for B15

v1:
- initial submission

[1] http://www.broadcom.com/products/Cable/Cable-Set-Top-Box-Solutions/BCM7445

Marc Carino (8):
  ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
  power: reset: Add reboot driver for brcmstb
  ARM: brcmstb: add debug UART for earlyprintk support
  ARM: do CPU-specific init for Broadcom Brahma15 cores
  ARM: brcmstb: add CPU binding for Broadcom Brahma15
  ARM: brcmstb: add misc. DT bindings for brcmstb
  ARM: brcmstb: gic: add compatible string for Broadcom Brahma15
  ARM: brcmstb: dts: add a reference DTS for Broadcom 7445

 .../devicetree/bindings/arm/brcm-brcmstb.txt       |   95 ++++++
 Documentation/devicetree/bindings/arm/cpus.txt     |    1 +
 Documentation/devicetree/bindings/arm/gic.txt      |    1 +
 arch/arm/Kconfig.debug                             |   16 +-
 arch/arm/boot/dts/bcm7445.dts                      |  111 +++++++
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/mach-bcm/Kconfig                          |   14 +
 arch/arm/mach-bcm/Makefile                         |    4 +
 arch/arm/mach-bcm/brcmstb.c                        |  110 +++++++
 arch/arm/mach-bcm/brcmstb.h                        |   38 +++
 arch/arm/mach-bcm/headsmp-brcmstb.S                |   34 ++
 arch/arm/mach-bcm/hotplug-brcmstb.c                |  334 ++++++++++++++++++++
 arch/arm/mm/proc-v7.S                              |   11 +
 drivers/power/reset/Kconfig                        |   10 +
 drivers/power/reset/Makefile                       |    1 +
 drivers/power/reset/brcmstb-reboot.c               |  120 +++++++
 16 files changed, 900 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
 create mode 100644 arch/arm/boot/dts/bcm7445.dts
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

