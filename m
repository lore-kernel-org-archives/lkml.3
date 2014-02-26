Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaBZJBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:01:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaBZJBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:01:03 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com, Jens Axboe <axboe@kernel.dk>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 1/2] cciss: Fallback to MSI rather than to INTx if MSI-X failed
Date: Wed, 26 Feb 2014 10:02:41 +0100
Message-Id: <ef248ef28d15d5e6813108a04b4d3532abb22125.1393404496.git.agordeev@redhat.com>
In-Reply-To: <cover.1393404496.git.agordeev@redhat.com>
References: <cover.1393404496.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver falls back to INTx mode when MSI-X
initialization failed. This is a suboptimal behaviour
for chips that also support MSI. This update changes that
behaviour and falls back to MSI mode in case MSI-X mode
initialization failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/cciss.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 036e8ab..73894ca 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4092,11 +4092,9 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 		if (err > 0) {
 			dev_warn(&h->pdev->dev,
 				"only %d MSI-X vectors available\n", err);
-			goto default_int_mode;
 		} else {
 			dev_warn(&h->pdev->dev,
 				"MSI-X init failed %d\n", err);
-			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.7.7.6

