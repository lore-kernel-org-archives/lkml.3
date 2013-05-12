Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3ELOYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:24:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65137 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3ELOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:24:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="46528037"
From: Dolev Raviv <draviv@codeaurora.org>
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V1 2/8] scsi: ufs: Fix the response UPIU length setting
Date: Sun, 12 May 2013 17:23:54 +0300
Message-Id: <1368368640-10167-3-git-send-email-draviv@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
References: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The response UPIU length should be in DWORD and not in bytes.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4ddc8be..7ce40a5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -807,7 +807,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
 		utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_req_ptr =
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
