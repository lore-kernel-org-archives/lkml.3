Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaBJAc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:32:29 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47886 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaBJAc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:32:28 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: ion: fix sparse non static symbol warnings
Date: Mon, 10 Feb 2014 09:32:22 +0900
Message-ID: <2249537.0tqhh5qnLv@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 08b77be03927d450810c07d3a4440dc8c32fe766 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 09:02:26 +0900
Subject: [PATCH] gpu: ion: fix sparse non static symbol warnings

Fixes the following sparse warnings:

drivers/staging/android/ion/ion_dummy_driver.c:26:19:
 warning: symbol 'idev' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:27:17:
 warning: symbol 'heaps' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:29:6:
 warning: symbol 'carveout_ptr' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:30:6:
 warning: symbol 'chunk_ptr' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:32:26:
 warning: symbol 'dummy_heaps' was not declared. Should it be static?
drivers/staging/android/ion/ion_dummy_driver.c:59:26:
 warning: symbol 'dummy_ion_pdata' was not declared. Should it be static?

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c |   12 ++++++------
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
-- 
1.7.9.5
---

