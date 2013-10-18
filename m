Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JSGVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:21:40 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11249 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944Ab3JSGVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:21:38 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 27/29] vmxnet3: Return -ENOSPC when not enough MSI-X vectors available
Date: Fri, 18 Oct 2013 19:12:27 +0200
Message-Id: <b016b15d6671a3d759610972d5643472a057cdb6.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3518173..3df7f32 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2752,7 +2752,10 @@ vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 				   "Failed to enable MSI-X, error: %d\n", err);
 			return err;
 		} else if (err < vector_threshold) {
-			break;
+			dev_info(&adapter->pdev->dev,
+				 "Number of MSI-Xs which can be allocated "
+				 "is lower than min threshold required.\n");
+			return -ENOSPC;
 		} else {
 			/* If fails to enable required number of MSI-x vectors
 			 * try enabling minimum number of vectors required.
@@ -2764,9 +2767,6 @@ vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 		}
 	}
 
-	dev_info(&adapter->pdev->dev,
-		 "Number of MSI-X interrupts which can be allocated "
-		 "is lower than min threshold required.\n");
 	return err;
 }
 
-- 
1.7.7.6

