Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaFDVhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:37:06 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34048 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaFDVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:37:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: mpt3sas_base.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:37:58 +0200
Message-Id: <1401917878-3324-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..b9a74f4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2233,7 +2233,8 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	u32 bios_version;
 
 	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
-	strncpy(desc, ioc->manu_pg0.ChipName, 16);
+	strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
+	desc[sizeof(desc) - 1] = '\0';
 	pr_info(MPT3SAS_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "\
 	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
 	    ioc->name, desc,
-- 
1.7.10.4

