Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaGWS3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:29:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43699 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbaGWS3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:29:42 -0400
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [linux-next PATCH] staging: android: ion: fix prefer kcalloc over kzalloc with multiply
Date: Thu, 24 Jul 2014 02:29:23 +0800
Message-Id: <1406140165-23503-1-git-send-email-wangchao19890207@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning of prefer kcalloc over kzalloc with multiply,
found under drivers/staging/android/ion/.

Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
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

