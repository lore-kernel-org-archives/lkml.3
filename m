Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBYHqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:46:25 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46626 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBYHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:46:24 -0500
Date: Tue, 25 Feb 2014 13:16:15 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Chanho Min <chanho.min@lge.com>, josh@joshtriplett.org
Subject: [PATCH 4/8] lib: Add prototype declarations in lib/clz_ctz.c
Message-ID: <c3db705984a4a5a7ed728fba7708e81d971f1a87.1393313946.git.rashika.kheria@gmail.com>
References: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declarations of functions in lib/clz_ctz.c. These
functions are required by GCC builtins and hence can not be removed
despite of their unreferenced appearance in kernel source.

This eliminates the following warning in lib/clz_ctz.c:
lib/clz_ctz.c:16:12: warning: no previous prototype for ‘__ctzsi2’ [-Wmissing-prototypes]
lib/clz_ctz.c:22:12: warning: no previous prototype for ‘__clzsi2’ [-Wmissing-prototypes]
lib/clz_ctz.c:44:12: warning: no previous prototype for ‘__clzdi2’ [-Wmissing-prototypes]
lib/clz_ctz.c:50:12: warning: no previous prototype for ‘__ctzdi2’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/clz_ctz.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/clz_ctz.c b/lib/clz_ctz.c
index a8f8379..2e11e48 100644
--- a/lib/clz_ctz.c
+++ b/lib/clz_ctz.c
@@ -6,6 +6,9 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ * The functions in this file aren't called directly, but are required by
+ * GCC builtins such as __builtin_ctz, and therefore they can't be removed
+ * despite appearing unreferenced in kernel source.
  *
  * __c[lt]z[sd]i2 can be overridden by linking arch-specific versions.
  */
@@ -13,18 +16,22 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 
+int __weak __ctzsi2(int val);
 int __weak __ctzsi2(int val)
 {
 	return __ffs(val);
 }
 EXPORT_SYMBOL(__ctzsi2);
 
+int __weak __clzsi2(int val);
 int __weak __clzsi2(int val)
 {
 	return 32 - fls(val);
 }
 EXPORT_SYMBOL(__clzsi2);
 
+int __weak __clzdi2(long val);
+int __weak __ctzdi2(long val);
 #if BITS_PER_LONG == 32
 
 int __weak __clzdi2(long val)
-- 
1.7.9.5

