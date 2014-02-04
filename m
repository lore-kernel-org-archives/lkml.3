Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaBDLVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:21:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaBDLPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:15:41 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Hiral Patel <hiralpat@cisco.com>,
        Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 07/22] fnic: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:53 +0100
Message-Id: <01c54a9cf2e52395c59bd663766c8d1071da0a33.1391512266.git.agordeev@redhat.com>
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
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/fnic/fnic_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 7d9b54a..0031c3e 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	    fnic->raw_wq_count >= m &&
 	    fnic->wq_copy_count >= o &&
 	    fnic->cq_count >= n + m + o) {
-		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
-				    n + m + o + 1)) {
+		if (pci_enable_msix_range(fnic->pdev, fnic->msix_entry,
+				          n + m + o + 1, n + m + o + 1) > 0) {
 			fnic->rq_count = n;
 			fnic->raw_wq_count = m;
 			fnic->wq_copy_count = o;
-- 
1.7.7.6

