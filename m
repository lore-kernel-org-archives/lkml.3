Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3LMOde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:33:34 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:54147 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3LMOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:33:32 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        arm@kernel.org, linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v4 0/2] ARM: mach-moxart: add MOXA ART SoC support
Date: Fri, 13 Dec 2013 15:33:06 +0100
Message-Id: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set adds MOXA ART SoC and platform support.

Changes since v3:
1. removed platform specific UART debug files,
   replaced by generic code under DEBUG_LL_UART_8250.

arch/arm/mach-moxart/*:
2. select DMA_OF and PHYLIB
3. remove .init_time hook
4. reinsert restart code that rely on watchdog register
   (watchdog maintainers rejected arm_pm_restart in watchdog code)
   assign arm_pm_restart from .init_machine
5. move to ARCH_MULTI_V4T (ARCH_MULTI_V4 was removed)

arch/arm/boot/dts/moxart-uc7112lx.dts:
6. remove comments
7. add "mdio0"/"mdio1" nodes
8. add phy-handle/phy-mode to "mac0"/"mac1" nodes
9. change bootargs (change root=/dev/mtdblock2 to root=/dev/mmcblk0p1)
10. add gpio-leds node "leds"
11. add gpio-keys-polled node "gpio_keys_polled"
12. rename "mmc" node "sdhci"

arch/arm/boot/dts/moxart.dtsi:
13. add fixed-clock node "ref12"
14. remove "clk" node, add nodes "clk_pll"/"clk_apb"
15. add gpio-rtc-* (sclk|data|reset) to "rtc" node
16. add "dma" node
17. remove second register from "gpio" node

Applies to next-20131213


Jonas Jensen (2):
  ARM: mach-moxart: add MOXA ART SoC platform files
  ARM: mach-moxart: add MOXA ART SoC device tree files

 Documentation/devicetree/bindings/arm/moxart.txt |  12 ++
 arch/arm/Kconfig                                 |   2 +
 arch/arm/Makefile                                |   1 +
 arch/arm/boot/dts/Makefile                       |   1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts            | 131 ++++++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi                    | 100 +++++++++++++++
 arch/arm/configs/moxart_defconfig                | 148 +++++++++++++++++++++++
 arch/arm/mach-moxart/Kconfig                     |  31 +++++
 arch/arm/mach-moxart/Makefile                    |   3 +
 arch/arm/mach-moxart/moxart.c                    |  75 ++++++++++++
 10 files changed, 504 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c

-- 
1.8.2.1

