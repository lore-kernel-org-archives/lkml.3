Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaBRKLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:11:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbaBRKLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:11:03 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH net-next 27/35] qlcnic: Cleanup qlcnic_enable_msix() return values
Date: Tue, 18 Feb 2014 11:11:56 +0100
Message-Id: <137c27c94c88423a6627162e9926f50ab681b30c.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index ba78c74..0c077cf 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -684,7 +684,7 @@ restore:
 int qlcnic_enable_msix(struct qlcnic_adapter *adapter, u32 num_msix)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	int err = -1, vector;
+	int err, vector;
 
 	if (!adapter->msix_entries) {
 		adapter->msix_entries = kcalloc(num_msix,
@@ -706,7 +706,7 @@ enable_msix:
 			adapter->flags |= QLCNIC_MSIX_ENABLED;
 			adapter->ahw->num_msix = num_msix;
 			dev_info(&pdev->dev, "using msi-x interrupts\n");
-			return err;
+			return 0;
 		} else if (err > 0) {
 			dev_info(&pdev->dev,
 				 "Unable to allocate %d MSI-X vectors, Available vectors %d\n",
@@ -715,12 +715,12 @@ enable_msix:
 			if (qlcnic_82xx_check(adapter)) {
 				num_msix = rounddown_pow_of_two(err);
 				if (err < QLCNIC_82XX_MINIMUM_VECTOR)
-					return -EIO;
+					return -ENOSPC;
 			} else {
 				num_msix = rounddown_pow_of_two(err - 1);
 				num_msix += 1;
 				if (err < QLCNIC_83XX_MINIMUM_VECTOR)
-					return -EIO;
+					return -ENOSPC;
 			}
 
 			if (qlcnic_82xx_check(adapter) &&
@@ -747,7 +747,7 @@ enable_msix:
 		}
 	}
 
-	return err;
+	return -EIO;
 }
 
 static int qlcnic_82xx_calculate_msix_vector(struct qlcnic_adapter *adapter)
-- 
1.7.7.6

