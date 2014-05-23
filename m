Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaEWIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:39:18 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:39553 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEWI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:29 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH 19/22] ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
Date: Fri, 23 May 2014 15:51:22 +0800
Message-Id: <1400831485-28576-20-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400831485-28576-1-git-send-email-wens@csie.org>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sun6i/sun8i have a UART in the RTC block group, which can be used
as an early console. This is most useful on sun8i as UART0 is muxed
with MMC0, which is not available if we boot from MMC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/Kconfig.debug | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index eab8ecb..9e22708 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -694,6 +694,14 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Allwinner A1X based platforms on the UART1.
 
+	config DEBUG_SUNXI_R_UART
+		bool "Kernel low-level debugging messages via sunXi R_UART"
+		depends on ARCH_SUNXI
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Allwinner A31 based platforms on the R_UART.
+
 	config TEGRA_DEBUG_UART_AUTO_ODMDATA
 		bool "Kernel low-level debugging messages via Tegra UART via ODMDATA"
 		depends on ARCH_TEGRA
@@ -1007,6 +1015,7 @@ config DEBUG_UART_PHYS
 	default 0x01c28400 if DEBUG_SUNXI_UART1
 	default 0x01d0c000 if DEBUG_DAVINCI_DA8XX_UART1
 	default 0x01d0d000 if DEBUG_DAVINCI_DA8XX_UART2
+	default 0x01f02800 if DEBUG_SUNXI_R_UART
 	default 0x02530c00 if DEBUG_KEYSTONE_UART0
 	default 0x02531000 if DEBUG_KEYSTONE_UART1
 	default 0x03010fe0 if ARCH_RPC
@@ -1072,6 +1081,7 @@ config DEBUG_UART_VIRT
 	default 0xf1600000 if ARCH_INTEGRATOR
 	default 0xf1c28000 if DEBUG_SUNXI_UART0
 	default 0xf1c28400 if DEBUG_SUNXI_UART1
+	default 0xf1f02800 if DEBUG_SUNXI_R_UART
 	default 0xf2100000 if DEBUG_PXA_UART1
 	default 0xf4090000 if ARCH_LPC32XX
 	default 0xf4200000 if ARCH_GEMINI
-- 
2.0.0.rc2

