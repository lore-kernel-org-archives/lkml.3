Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaERQNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:13:16 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61321 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaERQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:13:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:14:00 +0200
Message-Id: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index a97be01..60a988c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4367,7 +4367,8 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	dir = data_dir_flags[task->data_dir] << 8;
 	sata_cmd.tag = cpu_to_le32(tag);
-	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
+	if(pm8001_ha_dev)
+		sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
 	sata_cmd.ncqtag_atap_dir_m =
 		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
-- 
1.7.10.4

