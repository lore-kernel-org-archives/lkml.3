Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaBUPrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaBUPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:47:38 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jon Mason <jon.mason@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 1/4] ntb: Fix leakage of ntb_device::msix_entries[] array
Date: Fri, 21 Feb 2014 16:49:29 +0100
Message-Id: <7f4150adb1b01e79555af6a9e13f1c0e0df6fdac.1392996332.git.agordeev@redhat.com>
In-Reply-To: <cover.1392996332.git.agordeev@redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/ntb/ntb_hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 170e8e6..487169dd 100644
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
1.7.7.6

