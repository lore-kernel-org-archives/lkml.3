Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3FFMtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:49:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43836 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3FFMti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:49:38 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Use menuconfig instead of creating menus with an enabler first entry.
Date: Thu,  6 Jun 2013 05:49:35 -0700
Message-Id: <1370522975-451527-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be what most of the other drivers subdirectories do, and
makes menuconfig friendlier.

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 drivers/bcma/Kconfig | 9 ++++-----
 drivers/pps/Kconfig  | 8 ++------
 drivers/ssb/Kconfig  | 9 ++++-----
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 8b4221c..fee9b9f 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -3,16 +3,15 @@ config BCMA_POSSIBLE
 	depends on HAS_IOMEM && HAS_DMA
 	default y
 
-menu "Broadcom specific AMBA"
-	depends on BCMA_POSSIBLE
-
-config BCMA
+menuconfig BCMA
 	tristate "BCMA support"
 	depends on BCMA_POSSIBLE
 	help
 	  Bus driver for Broadcom specific Advanced Microcontroller Bus
 	  Architecture.
 
+if BCMA
+
 # Support for Block-I/O. SELECT this from the driver that needs it.
 config BCMA_BLOCKIO
 	bool
@@ -81,4 +80,4 @@ config BCMA_DEBUG
 
 	  If unsure, say N
 
-endmenu
+endif
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 7512e98..abfceb6 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -2,9 +2,7 @@
 # PPS support configuration
 #
 
-menu "PPS support"
-
-config PPS
+menuconfig PPS
 	tristate "PPS support"
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
@@ -38,10 +36,8 @@ config NTP_PPS
 
 	  It doesn't work on tickless systems at the moment.
 
-endif
-
 source drivers/pps/clients/Kconfig
 
 source drivers/pps/generators/Kconfig
 
-endmenu
+endif
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 5ff3a4f..c3b8357 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -3,10 +3,7 @@ config SSB_POSSIBLE
 	depends on HAS_IOMEM && HAS_DMA
 	default y
 
-menu "Sonics Silicon Backplane"
-	depends on SSB_POSSIBLE
-
-config SSB
+menuconfig SSB
 	tristate "Sonics Silicon Backplane support"
 	depends on SSB_POSSIBLE
 	help
@@ -21,6 +18,8 @@ config SSB
 
 	  If unsure, say N.
 
+if SSB
+
 # Common SPROM support routines
 config SSB_SPROM
 	bool
@@ -173,4 +172,4 @@ config SSB_DRIVER_GPIO
 
 	  If unsure, say N
 
-endmenu
+endif
-- 
1.8.2.1

