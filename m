Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaANCEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:04:53 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42333 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaANCEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:04:51 -0500
MIME-Version: 1.0
Date: Tue, 14 Jan 2014 10:04:49 +0800
Message-ID: <CAPgLHd9hJ4Fy7NpfT1vWt7aem_ey+YA==7f=u2MpazBKJDjSvQ@mail.gmail.com>
Subject: [PATCH -next] ion: Fix sparse non static symbol warnings
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/staging/android/ion/ion_dummy_driver.c:26:19: warning:
 symbol 'idev' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:27:17: warning:
 symbol 'heaps' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:29:6: warning:
 symbol 'carveout_ptr' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:30:6: warning:
 symbol 'chunk_ptr' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:32:26: warning:
 symbol 'dummy_heaps' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:59:26: warning:
 symbol 'dummy_ion_pdata' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 55b2002..b89004a 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -23,13 +23,13 @@
 #include "ion.h"
 #include "ion_priv.h"
 
-struct ion_device *idev;
-struct ion_heap **heaps;
+static struct ion_device *idev;
+static struct ion_heap **heaps;
 
-void *carveout_ptr;
-void *chunk_ptr;
+static void *carveout_ptr;
+static void *chunk_ptr;
 
-struct ion_platform_heap dummy_heaps[] = {
+static struct ion_platform_heap dummy_heaps[] = {
 		{
 			.id	= ION_HEAP_TYPE_SYSTEM,
 			.type	= ION_HEAP_TYPE_SYSTEM,
@@ -56,7 +56,7 @@ struct ion_platform_heap dummy_heaps[] = {
 		},
 };
 
-struct ion_platform_data dummy_ion_pdata = {
+static struct ion_platform_data dummy_ion_pdata = {
 	.nr = 4,
 	.heaps = dummy_heaps,
 };

