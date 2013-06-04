Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3FDFzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:55:47 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:45273 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3FDFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:55:44 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH v2 1/2] staging: gdm72xx: WIMAX_GDM72XX should depend on either USB or MMC
Date: Mon,  3 Jun 2013 22:55:38 -0700
Message-Id: <1370325339-19956-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gdm72xx driver needs to have either the USB or SDIO implementation
enabled to provide useful functionalities, so the driver should depend
on either USB or MMC. This patch makes WIMAX_GDM72XX depend on either
USB or MMC.

Also, WIMAX_GDM72XX needs to be built as a module if its dependent
interface, either USB or MMC, is built as a module. This patch enforces
that in the WIMAX_GDM72XX_USB and WIMAX_GDM72XX_SDIO dependency.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
index 6905913..dd47bd1 100644
--- a/drivers/staging/gdm72xx/Kconfig
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig WIMAX_GDM72XX
 	tristate "GCT GDM72xx WiMAX support"
-	depends on NET
+	depends on NET && (USB || MMC)
 	help
 	  Support for the GCT GDM72xx WiMAX chip
 
@@ -27,11 +27,11 @@ choice
 
 config WIMAX_GDM72XX_USB
 	bool "USB interface"
-	depends on USB
+	depends on (USB = y || USB = WIMAX_GDM72XX)
 
 config WIMAX_GDM72XX_SDIO
 	bool "SDIO interface"
-	depends on MMC
+	depends on (MMC = y || MMC = WIMAX_GDM72XX)
 
 endchoice
 
-- 
1.8.2.1

