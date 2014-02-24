Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBXILL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:11:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaBXILG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:11:06 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 01/23] be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:01 +0100
Message-Id: <7870f36835f20cbe81dfa1540e6671d486fda0b0.1393191330.git.agordeev@redhat.com>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
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
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..580192f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5284,12 +5284,10 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
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
 
 /*
-- 
1.7.7.6

