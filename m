Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLQKnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:43:47 -0500
Received: from 8bytes.org ([81.169.241.247]:60032 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaLQKnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:43:46 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jerry Hoemann <jerry.hoemann@hp.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/2] iommu/vt-d: Remove dead code in device_notifier
Date: Wed, 17 Dec 2014 11:43:37 +0100
Message-Id: <1418813017-24888-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418813017-24888-1-git-send-email-joro@8bytes.org>
References: <1418813017-24888-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This code only runs when action == BUS_NOTIFY_REMOVED_DEVICE,
so it can't be BUS_NOTIFY_DEL_DEVICE.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 7610121..40dfbc0 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4029,14 +4029,6 @@ static int device_notifier(struct notifier_block *nb,
 	if (action != BUS_NOTIFY_REMOVED_DEVICE)
 		return 0;
 
-	/*
-	 * If the device is still attached to a device driver we can't
-	 * tear down the domain yet as DMA mappings may still be in use.
-	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
-	 */
-	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
-		return 0;
-
 	domain = find_domain(dev);
 	if (!domain)
 		return 0;
-- 
1.9.1

