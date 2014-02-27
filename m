Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaB0LjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:39:12 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40736 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaB0LjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:39:10 -0500
Date: Thu, 27 Feb 2014 17:09:03 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, josh@joshtriplett.org
Subject: [PATCH 11/46] kernel: Add prototype declaration in kernel/gcov/base.c
Message-ID: <6fc7e35882693c30f7f7adad20838a123fac29c3.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declarations of functions in kernel/gcov/base.c. These
functions are required by GCC builtins and hence can not be removed
despite of their unreferenced appearance in kernel source.

This eliminates the following warning in kernel/gcov/base.c:
kernel/gcov/base.c:30:6: warning: no previous prototype for ‘__gcov_init’ [-Wmissing-prototypes]
kernel/gcov/base.c:58:6: warning: no previous prototype for ‘__gcov_flush’ [-Wmissing-prototypes]
kernel/gcov/base.c:64:6: warning: no previous prototype for ‘__gcov_merge_add’ [-Wmissing-prototypes]
kernel/gcov/base.c:70:6: warning: no previous prototype for ‘__gcov_merge_single’ [-Wmissing-prototypes]
kernel/gcov/base.c:76:6: warning: no previous prototype for‘__gcov_merge_delta’ [-Wmissing-prototypes]
kernel/gcov/base.c:82:6: warning: no previous prototype for ‘__gcov_merge_ior’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 kernel/gcov/base.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
index f45b75b..c0cb53a 100644
--- a/kernel/gcov/base.c
+++ b/kernel/gcov/base.c
@@ -27,6 +27,7 @@ static DEFINE_MUTEX(gcov_lock);
  * __gcov_init is called by gcc-generated constructor code for each object
  * file compiled with -fprofile-arcs.
  */
+void __gcov_init(struct gcov_info *info);
 void __gcov_init(struct gcov_info *info)
 {
 	static unsigned int gcov_version;
@@ -55,30 +56,35 @@ EXPORT_SYMBOL(__gcov_init);
  * These functions may be referenced by gcc-generated profiling code but serve
  * no function for kernel profiling.
  */
+void __gcov_flush(void);
 void __gcov_flush(void)
 {
 	/* Unused. */
 }
 EXPORT_SYMBOL(__gcov_flush);
 
+void __gcov_merge_add(gcov_type *counters, unsigned int n_counters);
 void __gcov_merge_add(gcov_type *counters, unsigned int n_counters)
 {
 	/* Unused. */
 }
 EXPORT_SYMBOL(__gcov_merge_add);
 
+void __gcov_merge_single(gcov_type *counters, unsigned int n_counters);
 void __gcov_merge_single(gcov_type *counters, unsigned int n_counters)
 {
 	/* Unused. */
 }
 EXPORT_SYMBOL(__gcov_merge_single);
 
+void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters);
 void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters)
 {
 	/* Unused. */
 }
 EXPORT_SYMBOL(__gcov_merge_delta);
 
+void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters);
 void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters)
 {
 	/* Unused. */
-- 
1.7.9.5

