Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3EMKDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:03:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10128 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3EMKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:03:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="46696473"
From: Dolev Raviv <draviv@codeaurora.org>
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V1 5/8] scsi: ufs: fix interrupt status clears
Date: Mon, 13 May 2013 13:02:15 +0300
Message-Id: <1368439340-26346-6-git-send-email-draviv@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
References: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to check the version to clear
the interrupt status. And the order is changed
prior to actual handling.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
Acked-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c342a38..f4293d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1478,11 +1478,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 
 	if (intr_status) {
+		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		ufshcd_sl_intr(hba, intr_status);
-
-		/* If UFSHCI 1.0 then clear interrupt status register */
-		if (hba->ufs_version == UFSHCI_VERSION_10)
-			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		retval = IRQ_HANDLED;
 	}
 	spin_unlock(hba->host->host_lock);
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
