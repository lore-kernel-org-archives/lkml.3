Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab3DIUNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:13:36 -0400
Received: from 8bytes.org ([85.214.48.195]:36416 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935712Ab3DIUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/9] iommu/amd: Properly initialize irq-table lock
Date: Tue,  9 Apr 2013 22:12:58 +0200
Message-Id: <1365538384-12426-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:32 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766c23672117617274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a lockdep warning.

Cc: stable@vger.kernel.org # >= v3.7
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 72fa570..33900b5 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3927,6 +3927,9 @@ static struct irq_remap_table *get_irq_table(u16 devid, bool ioapic)
 	if (!table)
 		goto out;
 
+	/* Initialize table spin-lock */
+	spin_lock_init(&table->lock);
+
 	if (ioapic)
 		/* Keep the first 32 indexes free for IOAPIC interrupts */
 		table->min_index = 32;
-- 
1.7.9.5


