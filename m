Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3LCXsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:48:50 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55066
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778Ab3LCXi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:58 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 18:38:53 EST
Message-Id: <20131203233250.188934046@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:42 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/41] staging/zsmalloc: Replace instances of using __get_cpu_var for address calculation
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_staging
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the use of __get_cpu_var for address calculation with
this_cpu_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/staging/zsmalloc/zsmalloc-main.c
===================================================================
--- linux.orig/drivers/staging/zsmalloc/zsmalloc-main.c	2013-12-02 16:07:49.564639939 -0600
+++ linux/drivers/staging/zsmalloc/zsmalloc-main.c	2013-12-02 16:07:49.554640215 -0600
@@ -1003,7 +1003,7 @@ void *zs_map_object(struct zs_pool *pool
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &get_cpu_var(zs_map_area);
+	area = this_cpu_ptr(&zs_map_area);
 	area->vm_mm = mm;
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
@@ -1037,7 +1037,7 @@ void zs_unmap_object(struct zs_pool *poo
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &__get_cpu_var(zs_map_area);
+	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
 		kunmap_atomic(area->vm_addr);
 	else {

