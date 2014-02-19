Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaBSI5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:57:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbaBSI4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:42 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH 6/9] skd: Fix out of array boundary access
Date: Wed, 19 Feb 2014 09:58:18 +0100
Message-Id: <06ae7409fef678184a982ace652a299c0018dab8.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling MSI-X, interrupts are requested for SKD_MAX_MSIX_COUNT
entries in skdev->msix_entries array, while the number of actually
allocated entries is skdev->msix_count. This might lead to an out of
boundary access in case number of allocated entries is less than
SKD_MAX_MSIX_COUNT. This update fixes the described misbehaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/skd_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index eb6e1e0..3fa0918 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3989,7 +3989,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++) {
+	for (i = 0; i < skdev->msix_count; i++) {
 		qentry = &skdev->msix_entries[i];
 		snprintf(qentry->isr_name, sizeof(qentry->isr_name),
 			 "%s%d-msix %s", DRV_NAME, skdev->devno,
-- 
1.7.7.6

