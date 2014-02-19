Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaBSI4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbaBSI4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:46 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH 8/9] skd: Use unified access to skdev->msix_entries throughout the code
Date: Wed, 19 Feb 2014 09:58:20 +0100
Message-Id: <57ee0dad76cc5b29c5ebba644971baedecc0c63c.1392799752.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/skd_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index d0550ba..1cd1095 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3977,8 +3977,8 @@ static int skd_acquire_msix(struct skd_device *skdev)
 		goto msix_out;
 	}
 
-	qentry = skdev->msix_entries;
 	for (i = 0; i < skdev->msix_count; i++) {
+		qentry = &skdev->msix_entries[i];
 		qentry->vector = entries[i].vector;
 		qentry->entry = entries[i].entry;
 		qentry->rsp = NULL;
@@ -3987,7 +3987,6 @@ static int skd_acquire_msix(struct skd_device *skdev)
 			 skdev->name, __func__, __LINE__,
 			 pci_name(pdev), skdev->name,
 			 i, qentry->vector, qentry->entry);
-		qentry++;
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-- 
1.7.7.6

