Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaHLQSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:18:46 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61279 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaHLQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:18:43 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, ccross@android.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 5/5] staging: android: ion: ion_dummy_driver.c Fix checkpatch warning
Date: Tue, 12 Aug 2014 23:17:30 +0700
Message-Id: <1407860250-9779-6-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix coding style

- Replace kzalloc() by kcalloc()
- Remove return of void function

Tested by compilation

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 3a45e79..f3ea1c3 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -68,7 +68,7 @@ static int __init ion_dummy_init(void)
 	int i, err;
 
 	idev = ion_device_create(NULL);
-	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
+	heaps = kcalloc(dummy_ion_pdata.nr, sizeof(struct ion_heap *),
 			GFP_KERNEL);
 	if (!heaps)
 		return -ENOMEM;
@@ -152,7 +152,5 @@ static void __exit ion_dummy_exit(void)
 				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
 		chunk_ptr = NULL;
 	}
-
-	return;
 }
 __exitcall(ion_dummy_exit);
-- 
1.9.3

