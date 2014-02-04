Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaBDLQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:16:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbaBDLQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:16:06 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 21/22] qla4xxx: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:07 +0100
Message-Id: <eb9c6c476786ff901512e46859f0d59a5e62170d.1391512266.git.agordeev@redhat.com>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: iscsi-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/qla4xxx/ql4_nx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index d001202..7f5412d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3805,8 +3805,9 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
 	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
 		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
 
-	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
-	if (ret) {
+	ret = pci_enable_msix_range(ha->pdev, entries,
+				    ARRAY_SIZE(entries), ARRAY_SIZE(entries));
+	if (ret < 0) {
 		ql4_printk(KERN_WARNING, ha,
 		    "MSI-X: Failed to enable support -- %d/%d\n",
 		    QLA_MSIX_ENTRIES, ret);
-- 
1.7.7.6

