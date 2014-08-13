Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaHMNjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:39:15 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41640 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHMNjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:39:14 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ccross@android.com, swetland@google.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, joe@perches.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH V3 1/3] staging: android: ion: ion_dummy_driver.c Replace kzalloc() by kcalloc()
Date: Wed, 13 Aug 2014 20:37:04 +0700
Message-Id: <1407937026-15791-1-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warning
Tested by compilation only.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 3a45e79..6d0a38a 100644
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
-- 
1.9.3

