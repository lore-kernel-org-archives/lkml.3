Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbaGWXDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:03:07 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:44019 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbaGWXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:03:06 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, paul.gortmaker@windriver.com,
        gang.chen.5i5j@gmail.com, yongjun_wei@trendmicro.com.cn,
        dan.carpenter@oracle.com, tomas.winkler@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Change kzalloc to kcalloc
Date: Wed, 23 Jul 2014 19:03:01 -0400
Message-Id: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the call to kzalloc to kcalloc in ion_dummy_driver
for allocating the heap.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 3a45e79..8883432 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -67,9 +67,8 @@ static int __init ion_dummy_init(void)
 {
 	int i, err;
 
	idev = ion_device_create(NULL);
-	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
-			GFP_KERNEL);
+	heaps = kcalloc(*dummy_ion_pdata.nr , sizeof((struct ion_heap *) *dummy_ion_pdata.nr) , GFP_KERNEL);
 	if (!heaps)
 		return -ENOMEM;
 
-- 
1.9.1

