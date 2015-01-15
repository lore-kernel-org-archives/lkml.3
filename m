Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbbAOWCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:02:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755936AbbAOV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:52 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 08/17] ARM: at91: stop using HAVE_AT91_DBGUx
Date: Thu, 15 Jan 2015 22:58:11 +0100
Message-Id: <1421359100-8930-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove SOC_SAM9xxx options, stop using HAVE_AT91_DBGUx.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/Kconfig.debug     |  6 +++---
 arch/arm/mach-at91/Kconfig | 19 -------------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e34d24949c6a..42a38731da99 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -117,17 +117,17 @@ choice
 	config AT91_DEBUG_LL_DBGU0
 		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10, 9rl, 9x5, 9n12"
 		select DEBUG_AT91_UART
-		depends on HAVE_AT91_DBGU0
+		depends on SOC_AT91RM9200 || SOC_AT91SAM9
 
 	config AT91_DEBUG_LL_DBGU1
 		bool "Kernel low-level debugging on 9263, 9g45 and sama5d3"
 		select DEBUG_AT91_UART
-		depends on HAVE_AT91_DBGU1
+		depends on SOC_AT91SAM9 || SOC_SAMA5
 
 	config AT91_DEBUG_LL_DBGU2
 		bool "Kernel low-level debugging on sama5d4"
 		select DEBUG_AT91_UART
-		depends on HAVE_AT91_DBGU2
+		depends on SOC_SAMA5
 
 	config DEBUG_BCM2835
 		bool "Kernel low-level debugging on BCM2835 PL011 UART"
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index b7dcef50db23..c6956b863b9d 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -6,15 +6,6 @@ config HAVE_AT91_UTMI
 config HAVE_AT91_USB_CLK
 	bool
 
-config HAVE_AT91_DBGU0
-	bool
-
-config HAVE_AT91_DBGU1
-	bool
-
-config HAVE_AT91_DBGU2
-	bool
-
 config COMMON_CLK_AT91
 	bool
 	select COMMON_CLK
@@ -70,7 +61,6 @@ config SOC_SAMA5D3
 	bool "SAMA5D3 family"
 	select SOC_SAMA5
 	select HAVE_FB_ATMEL
-	select HAVE_AT91_DBGU1
 	select HAVE_AT91_UTMI
 	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
@@ -81,7 +71,6 @@ config SOC_SAMA5D3
 config SOC_SAMA5D4
 	bool "SAMA5D4 family"
 	select SOC_SAMA5
-	select HAVE_AT91_DBGU2
 	select CLKSRC_MMIO
 	select CACHE_L2X0
 	select CACHE_PL310
@@ -101,12 +90,10 @@ config SOC_AT91RM9200
 	select COMMON_CLK_AT91
 	select CPU_ARM920T
 	select GENERIC_CLOCKEVENTS
-	select HAVE_AT91_DBGU0
 	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9260
 	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
-	select HAVE_AT91_DBGU0
 	select SOC_AT91SAM9
 	select HAVE_AT91_USB_CLK
 	help
@@ -115,7 +102,6 @@ config SOC_AT91SAM9260
 
 config SOC_AT91SAM9261
 	bool "AT91SAM9261 or AT91SAM9G10"
-	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_USB_CLK
@@ -124,21 +110,18 @@ config SOC_AT91SAM9261
 
 config SOC_AT91SAM9263
 	bool "AT91SAM9263"
-	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9RL
 	bool "AT91SAM9RL"
-	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
 
 config SOC_AT91SAM9G45
 	bool "AT91SAM9G45 or AT91SAM9M10 families"
-	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
@@ -149,7 +132,6 @@ config SOC_AT91SAM9G45
 
 config SOC_AT91SAM9X5
 	bool "AT91SAM9x5 family"
-	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
@@ -164,7 +146,6 @@ config SOC_AT91SAM9X5
 
 config SOC_AT91SAM9N12
 	bool "AT91SAM9N12 family"
-	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_USB_CLK
-- 
2.1.0

