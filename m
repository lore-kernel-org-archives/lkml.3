Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaDHCAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:00:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:26266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbaDHB7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="488940354"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 4/9] ntb: Fix leakage of ntb_device::msix_entries[] array
Date: Mon,  7 Apr 2014 17:52:49 -0700
Message-Id: <1396918374-5196-5-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 2774d35..0e8ae70 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1281,6 +1281,7 @@ static void ntb_free_interrupts(struct ntb_device *ndev)
 				free_irq(msix->vector, &ndev->db_cb[i]);
 		}
 		pci_disable_msix(pdev);
+		kfree(ndev->msix_entries);
 	} else {
 		free_irq(pdev->irq, ndev);
 
-- 
1.8.3.2

