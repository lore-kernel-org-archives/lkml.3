Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaBZK3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:29:31 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34267 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaBZK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:29:28 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v7 0/9] ARM: brcmstb: Add Broadcom STB SoC support
Date: Wed, 26 Feb 2014 02:29:03 -0800
Message-Id: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the board support package for the
Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
minimal set of code needed for a BCM7445-based board to boot
the Linux kernel.

These changes heavily leverage the OF/devicetree framework. The
machine is also built into the multi-platform ARMv7 image.

v7:
- rebase to v3.14-rc4
- detect and apply ARM erratum 798181 to Brahma15 CPUs
- split-up bcm7445.dts into a common dtsi and board-specific dts

v6 (https://lkml.org/lkml/2014/2/3/493):
- rebased to v3.14-rc1
- utilize common APIs for handling CPU power-down
- drop deprecated __cpuinit attributes

v5 (https://lkml.org/lkml/2014/1/21/640):
- rebased to v3.13 tag
- make UART DT node a child of 'rdb' node
- fix ordering of debug UART entries

v4 (https://lkml.org/lkml/2014/1/17/455):
- make a reboot driver and put it in the drivers folder
- rework DT bindings to leverage 'syscon'
- rework BSP code to use 'syscon' for all register mappings
- misc. tweaks per suggestions from v3

v3 (https://lkml.org/lkml/2014/1/14/696):
- rebased to v3.13-rc8
- switched to using 'multi_v7_defconfig'
- eliminated dependence on compile-time peripheral register access
- moved DT node iomap out from 'init_early'
- misc. minor cleanups from mailing-list discussion for v2

v2 (https://lkml.org/lkml/2013/11/26/570):
- rebased to v3.13-rc1
- moved implementation to 'mach-bcm' folder
- added CPU init for B16RM

v1:
- initial submission

[1] http://www.broadcom.com/products/Cable/Cable-Set-Top-Box-Solutions/BCM7445

Gregory Fong (1):
  ARM: Enable erratum 798181 for Broadcom Brahma-B15

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
 arch/arm/Kconfig.debug                             |   15 +-
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |   14 +
 arch/arm/boot/dts/bcm7445.dtsi                     |  107 +++++++
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/kernel/smp_tlb.c                          |   20 +-
 arch/arm/mach-bcm/Kconfig                          |   15 +
 arch/arm/mach-bcm/Makefile                         |    4 +
 arch/arm/mach-bcm/brcmstb.c                        |  104 +++++++
 arch/arm/mach-bcm/brcmstb.h                        |   38 +++
 arch/arm/mach-bcm/headsmp-brcmstb.S                |   33 ++
 arch/arm/mach-bcm/hotplug-brcmstb.c                |  311 ++++++++++++++++++++
 arch/arm/mm/proc-v7.S                              |   11 +
 drivers/power/reset/Kconfig                        |   10 +
 drivers/power/reset/Makefile                       |    1 +
 drivers/power/reset/brcmstb-reboot.c               |  120 ++++++++
 18 files changed, 892 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
 create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
 create mode 100644 arch/arm/boot/dts/bcm7445.dtsi
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

