Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3BFIuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:50:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab3BFIuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:50:13 -0500
From: Hannes Reinecke <hare@suse.de>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] dmar: Zero out memory
Date: Wed,  6 Feb 2013 09:50:10 +0100
Message-Id: <1360140610-48309-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemcheck complained about the use of uninitialized memory.
So there.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 86e2f4a..2623a57 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1040,7 +1040,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 
 	qi->desc = page_address(desc_page);
 
-	qi->desc_status = kmalloc(QI_LENGTH * sizeof(int), GFP_ATOMIC);
+	qi->desc_status = kzalloc(QI_LENGTH * sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
 		free_page((unsigned long) qi->desc);
 		kfree(qi);
