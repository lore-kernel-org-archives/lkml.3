Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaGBI0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:26:51 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:59712 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaGBI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:26:49 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH] staging: gdm72xx: add help text to Kconfig
Date: Wed,  2 Jul 2014 01:26:48 -0700
Message-Id: <1404289608-16224-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The descriptions are provided by GCT Semiconductor, Inc.

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/Kconfig | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
index dd8a391..5836503 100644
--- a/drivers/staging/gdm72xx/Kconfig
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -6,21 +6,29 @@ menuconfig WIMAX_GDM72XX
 	tristate "GCT GDM72xx WiMAX support"
 	depends on NET && (USB || MMC)
 	help
-	  Support for the GCT GDM72xx WiMAX chip
+	  Support a WiMAX module based on the GCT GDM72xx WiMAX chip.
 
 if WIMAX_GDM72XX
 
 config WIMAX_GDM72XX_QOS
 	bool "Enable QoS support"
 	default n
+	help
+	  Enable Quality of Service support based on the data protocol of
+	  transmitting packets.
 
 config WIMAX_GDM72XX_K_MODE
 	bool "Enable K mode"
 	default n
+	help
+	  Enable support for proprietary functions for KT (Korea Telecom).
 
 config WIMAX_GDM72XX_WIMAX2
 	bool "Enable WiMAX2 support"
 	default n
+	help
+	  Enable support for transmitting multiple packets (packet
+	  aggregation) from the WiMAX module to the host processor.
 
 choice
 	prompt "Select interface"
@@ -28,10 +36,16 @@ choice
 config WIMAX_GDM72XX_USB
 	bool "USB interface"
 	depends on (USB = y || USB = WIMAX_GDM72XX)
+	help
+	  Select this option if the WiMAX module interfaces with the host
+	  processor via USB.
 
 config WIMAX_GDM72XX_SDIO
 	bool "SDIO interface"
 	depends on (MMC = y || MMC = WIMAX_GDM72XX)
+	help
+	  Select this option if the WiMAX module interfaces with the host
+	  processor via SDIO.
 
 endchoice
 
@@ -40,6 +54,9 @@ if WIMAX_GDM72XX_USB
 config WIMAX_GDM72XX_USB_PM
 	bool "Enable power management support"
 	depends on PM_RUNTIME
+	help
+	  Enable USB power management in order to reduce power consumption
+	  while the interface is not in use.
 
 endif # WIMAX_GDM72XX_USB
 
-- 
2.0.0.526.g5318336

