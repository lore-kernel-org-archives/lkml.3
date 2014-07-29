Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaG2WQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:16:52 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43870 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbaG2WQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:16:34 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v5 4/4] Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option
Date: Wed, 30 Jul 2014 00:15:55 +0200
Message-Id: <1406672155-13187-5-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
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
index 06c96d5..21c3b3c 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -812,12 +812,10 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 			PHASE_NOT_RESET);
 		RTSX_WRITE_REG(chip, CLK_CTL, CHANGE_CLK, 0);
 	} else {
-#ifdef CONFIG_RTS5208_DEBUG
 		rtsx_read_register(chip, SD_VP_CTL, &val);
 		dev_dbg(rtsx_dev(chip), "SD_VP_CTL: 0x%x\n", val);
 		rtsx_read_register(chip, SD_DCMPS_CTL, &val);
 		dev_dbg(rtsx_dev(chip), "SD_DCMPS_CTL: 0x%x\n", val);
-#endif
 
 		if (ddr_rx) {
 			RTSX_WRITE_REG(chip, SD_VP_CTL, PHASE_CHANGE,
@@ -863,12 +861,11 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 	return STATUS_SUCCESS;
 
 Fail:
-#ifdef CONFIG_RTS5208_DEBUG
 	rtsx_read_register(chip, SD_VP_CTL, &val);
 	dev_dbg(rtsx_dev(chip), "SD_VP_CTL: 0x%x\n", val);
 	rtsx_read_register(chip, SD_DCMPS_CTL, &val);
 	dev_dbg(rtsx_dev(chip), "SD_DCMPS_CTL: 0x%x\n", val);
-#endif
+
 	rtsx_write_register(chip, SD_DCMPS_CTL, DCMPS_CHANGE, 0);
 	rtsx_write_register(chip, SD_VP_CTL, PHASE_CHANGE, 0);
 	wait_timeout(10);
-- 
2.0.0

