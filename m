Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbaGPSE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:04:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965602AbaGPSEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:04:55 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 01/23] be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 20:05:05 +0200
Message-Id: <c59d60c1d8b848222bbac6d32c314c9dfbfb13f2.1405533479.git.agordeev@redhat.com>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 56467df..1f63169 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5278,12 +5278,10 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 	for (i = 0; i <= phba->num_cpus; i++)
 		phba->msix_entries[i].entry = i;
 
-	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				 (phba->num_cpus + 1));
+	status = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				       phba->num_cpus + 1);
 	if (!status)
 		phba->msix_enabled = true;
-
-	return;
 }
 
 static void be_eqd_update(struct beiscsi_hba *phba)
-- 
1.7.7.6

