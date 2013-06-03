Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3FCR37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:29:59 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:37857 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab3FCR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:29:57 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 13:29:57 EDT
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        benchan@chromium.org, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: WIMAX_GDM72XX should depend on either USB or MMC
Date: Mon,  3 Jun 2013 10:23:45 -0700
Message-Id: <1370280225-27479-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gdm72xx driver needs to have either the USB or SDIO implementation
enabled to provide useful functionalities, so the driver should depend
on either USB or MMC.

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
index 6905913..8af0dd4 100644
--- a/drivers/staging/gdm72xx/Kconfig
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig WIMAX_GDM72XX
 	tristate "GCT GDM72xx WiMAX support"
-	depends on NET
+	depends on NET && (USB || MMC)
 	help
 	  Support for the GCT GDM72xx WiMAX chip
 
-- 
1.8.2.1

