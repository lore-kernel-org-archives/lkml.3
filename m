Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3ENHJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:09:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50896 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3ENHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:09:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,667,1363158000"; 
   d="scan'208";a="47041278"
From: Dolev Raviv <draviv@codeaurora.org>
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2 6/9] scsi: ufs: fix interrupt status clears
Date: Tue, 14 May 2013 10:08:45 +0300
Message-Id: <1368515328-31535-7-git-send-email-draviv@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
References: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
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
