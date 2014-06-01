Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaFANMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:12:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62979 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaFANMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:12:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:13:30 +0200
Message-Id: <1401628410-17824-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d70587f..add019b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -948,7 +948,7 @@ static int
 pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 scratch3_value;
-	int ret;
+	int ret = -1;
 
 	/* Read encryption status from SCRATCH PAD 3 */
 	scratch3_value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
@@ -982,7 +982,7 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->encrypt_info.status = 0xFFFFFFFF;
 		pm8001_ha->encrypt_info.cipher_mode = 0;
 		pm8001_ha->encrypt_info.sec_mode = 0;
-		return 0;
+		ret = 0;
 	} else if ((scratch3_value & SCRATCH_PAD3_ENC_MASK) ==
 				SCRATCH_PAD3_ENC_DIS_ERR) {
 		pm8001_ha->encrypt_info.status =
@@ -1004,7 +1004,6 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
 			pm8001_ha->encrypt_info.sec_mode,
 			pm8001_ha->encrypt_info.status));
-		ret = -1;
 	} else if ((scratch3_value & SCRATCH_PAD3_ENC_MASK) ==
 				 SCRATCH_PAD3_ENC_ENA_ERR) {
 
@@ -1028,7 +1027,6 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
 			pm8001_ha->encrypt_info.sec_mode,
 			pm8001_ha->encrypt_info.status));
-		ret = -1;
 	}
 	return ret;
 }
-- 
1.7.10.4

