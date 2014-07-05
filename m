Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaGEMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:09:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34918 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaGEMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:09:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: backlight: ili922x.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:11:10 +0200
Message-Id: <1404562270-18387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/backlight/ili922x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index ea67fe1..06936c8 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -251,7 +251,7 @@ static int ili922x_write(struct spi_device *spi, u8 reg, u16 value)
 	struct spi_transfer xfer_regindex, xfer_regvalue;
 	unsigned char tbuf[CMD_BUFSIZE];
 	unsigned char rbuf[CMD_BUFSIZE];
-	int ret, len = 0;
+	int ret;
 
 	memset(&xfer_regindex, 0, sizeof(struct spi_transfer));
 	memset(&xfer_regvalue, 0, sizeof(struct spi_transfer));
@@ -273,7 +273,6 @@ static int ili922x_write(struct spi_device *spi, u8 reg, u16 value)
 	ret = spi_sync(spi, &msg);
 
 	spi_message_init(&msg);
-	len = 0;
 	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_REG,
 					 START_RW_WRITE));
 	tbuf[1] = set_tx_byte((value & 0xFF00) >> 8);
-- 
1.7.10.4

