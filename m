Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3K0AWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:22:46 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43244 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3K0AWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:22:45 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v2 0/6] ARM: brcmstb: Add Broadcom STB SoC support
Date: Tue, 26 Nov 2013 16:22:22 -0800
Message-Id: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the board support package for the
Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
minimal set of code needed for a BCM7445-based board to boot
the Linux kernel.

These changes heavily leverage the OF/devicetree framework.

v2:
- rebased to v3.13-rc1
- moved implementation to 'mach-bcm' folder
- added CPU init for B15

v1:
- initial submission

[1] http://www.broadcom.com/products/Cable/Cable-Set-Top-Box-Solutions/BCM7445

Marc Carino (6):
  ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
  ARM: do CPU-specific init for Broadcom Brahma15 cores
  ARM: brcmstb: add CPU binding for Broadcom Brahma15
  ARM: brcmstb: add misc. DT bindings for brcm,brcmstb
  ARM: brcmstb: gic: add compatible string for Broadcom Brahma15
  ARM: brcmstb: dts: add a reference DTS for Broadcom 7445

 .../devicetree/bindings/arm/brcm-brcmstb.txt       |   72 +++++++
 Documentation/devicetree/bindings/arm/cpus.txt     |    1 +
 Documentation/devicetree/bindings/arm/gic.txt      |    1 +
 arch/arm/Kconfig.debug                             |   16 ++-
 arch/arm/boot/dts/brcmstb-7445.dts                 |  115 +++++++++++
 arch/arm/configs/brcmstb_defconfig                 |  127 ++++++++++++
 arch/arm/mach-bcm/Kconfig                          |   18 ++
 arch/arm/mach-bcm/Makefile                         |    2 +
 arch/arm/mach-bcm/brcmstb.c                        |  205 ++++++++++++++++++++
 arch/arm/mach-bcm/brcmstb.h                        |   70 +++++++
 arch/arm/mach-bcm/headsmp-brcmstb.S                |   29 +++
 arch/arm/mach-bcm/hotplug-brcmstb.c                |  203 +++++++++++++++++++
 arch/arm/mm/proc-v7.S                              |   11 +
 13 files changed, 869 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
 create mode 100644 arch/arm/boot/dts/brcmstb-7445.dts
 create mode 100644 arch/arm/configs/brcmstb_defconfig
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c

