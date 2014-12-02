Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbaLBVZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:25:53 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:58516 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932976AbaLBVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:24:42 -0500
Message-Id: <20141202212439.804957918@linux.com>
Date: Tue, 02 Dec 2014 15:24:31 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Update local_ops.txt to reflect this_cpu operations
References: <20141202212429.996456533@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=local_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to reflect changes due to the availability
of this_cpu operations.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/asm-generic/percpu.h | 5 -----
 1 file changed, 5 deletions(-)

Index: linux/Documentation/local_ops.txt
===================================================================
--- linux.orig/Documentation/local_ops.txt
+++ linux/Documentation/local_ops.txt
@@ -8,6 +8,11 @@ to implement them for any given architec
 properly. It also stresses on the precautions that must be taken when reading
 those local variables across CPUs when the order of memory writes matters.
 
+Note that local_t based operations are not recommended for general kernel use.
+Please use the this_cpu operations instead unless there is really a special purpose.
+Most uses of local_t in the kernel have been replaced by this_cpu operations.
+this_cpu operations combine the relocation with the local_t like semantics in
+a single instruction and yield more compact and faster executing code.
 
 
 * Purpose of local atomic operations
@@ -87,10 +92,10 @@ the per cpu variable. For instance :
 	local_inc(&get_cpu_var(counters));
 	put_cpu_var(counters);
 
-If you are already in a preemption-safe context, you can directly use
-__get_cpu_var() instead.
+If you are already in a preemption-safe context, you can use
+this_cpu_ptr() instead.
 
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 
 
@@ -134,7 +139,7 @@ static void test_each(void *info)
 {
 	/* Increment the counter from a non preemptible context */
 	printk("Increment on cpu %d\n", smp_processor_id());
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 	/* This is what incrementing the variable would look like within a
 	 * preemptible context (it disables preemption) :

