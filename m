Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaE2XJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:09:30 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50422 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaE2XJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:09:29 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix to remove null pointer checks that could never happen
Date: Fri, 30 May 2014 01:10:24 +0200
Message-Id: <1401405024-11221-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index a97be01..721d059 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4398,7 +4398,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 
 	/* Check for read log for failed drive and return */
 	if (sata_cmd.sata_fis.command == 0x2f) {
-		if (pm8001_ha_dev && ((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
+		if (((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
 			(pm8001_ha_dev->id & NCQ_ABORT_ALL_FLAG) ||
 			(pm8001_ha_dev->id & NCQ_2ND_RLE_FLAG))) {
 			struct task_status_struct *ts;
-- 
1.7.10.4

