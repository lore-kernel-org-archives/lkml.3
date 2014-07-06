Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaGFQON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:14:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50622 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaGFQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:13:16 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 3/4] Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option
Date: Sun,  6 Jul 2014 18:12:17 +0200
Message-Id: <1404663138-21333-4-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RTS5208_DEBUG is no more needed, we rely on dynamic debug config options
instead.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/Kconfig | 7 -------
 drivers/staging/rts5208/sd.c    | 5 +----
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/rts5208/Kconfig b/drivers/staging/rts5208/Kconfig
index 055655c..05c990f 100644
--- a/drivers/staging/rts5208/Kconfig
+++ b/drivers/staging/rts5208/Kconfig
@@ -6,10 +6,3 @@ config RTS5208
 	  PCI-E card reader rts5208/rts5288.
 
 	  If this driver is compiled as a module, it will be named rts5208.
-
-config RTS5208_DEBUG
-	bool "Realtek PCI-E Card Reader RTS5208/5288 verbose debug"
-	depends on RTS5208
-	help
-	  Say Y here in order to have the rts5208 code generate
-	  verbose debugging messages.
diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
index 7daa230..94003a3 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -812,12 +812,10 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 			PHASE_NOT_RESET);
 		RTSX_WRITE_REG(chip, CLK_CTL, CHANGE_CLK, 0);
 	} else {
-#ifdef CONFIG_RTS5208_DEBUG
 		rtsx_read_register(chip, SD_VP_CTL, &val);
 		pr_debug("SD_VP_CTL: 0x%x\n", val);
 		rtsx_read_register(chip, SD_DCMPS_CTL, &val);
 		pr_debug("SD_DCMPS_CTL: 0x%x\n", val);
-#endif
 
 		if (ddr_rx) {
 			RTSX_WRITE_REG(chip, SD_VP_CTL, PHASE_CHANGE,
@@ -863,12 +861,11 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 	return STATUS_SUCCESS;
 
 Fail:
-#ifdef CONFIG_RTS5208_DEBUG
 	rtsx_read_register(chip, SD_VP_CTL, &val);
 	pr_debug("SD_VP_CTL: 0x%x\n", val);
 	rtsx_read_register(chip, SD_DCMPS_CTL, &val);
 	pr_debug("SD_DCMPS_CTL: 0x%x\n", val);
-#endif
+
 	rtsx_write_register(chip, SD_DCMPS_CTL, DCMPS_CHANGE, 0);
 	rtsx_write_register(chip, SD_VP_CTL, PHASE_CHANGE, 0);
 	wait_timeout(10);
-- 
2.0.0

