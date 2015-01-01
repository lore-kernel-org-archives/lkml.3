Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbbAAQwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:52:02 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39212 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbAAQwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:52:01 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: mantis: mantis_core.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:55:01 +0100
Message-Id: <1420131301-30273-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function write_eeprom_byte() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/mantis/mantis_core.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_core.c b/drivers/media/pci/mantis/mantis_core.c
index 684d906..82220ea 100644
--- a/drivers/media/pci/mantis/mantis_core.c
+++ b/drivers/media/pci/mantis/mantis_core.c
@@ -56,29 +56,6 @@ static int read_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
 	return 0;
 }
 
-static int write_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
-{
-	int err;
-
-	struct i2c_msg msg = {
-		.addr = 0x50,
-		.flags = 0,
-		.buf = data,
-		.len = length
-	};
-
-	err = i2c_transfer(&mantis->adapter, &msg, 1);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1,
-			"ERROR: i2c write: < err=%i length=0x%02x d0=0x%02x, d1=0x%02x >",
-			err, length, data[0], data[1]);
-
-		return err;
-	}
-
-	return 0;
-}
-
 static int get_mac_address(struct mantis_pci *mantis)
 {
 	int err;
-- 
1.7.10.4

