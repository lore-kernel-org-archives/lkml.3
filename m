Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab3ICTPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:15:49 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:48160 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933901Ab3ICTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:15:46 -0400
X-Greylist: delayed 923 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 15:15:45 EDT
Message-ID: <00000140e53266ac-e4579140-3a1e-47a1-a338-e66fcacfdeb9-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 3 Sep 2013 19:00:20 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [gcv v4 02/38] percpu: Make __verify_pcu_ptr handle per cpu pointers to arrays
References: <20130903190014.794420260@linux.com>
X-SES-Outgoing: 2013.09.03-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__verify_pcpu_ptr() will cause a compilation failure if the type of the
pointer is a pointer to a fixed array of objects. Adding zero to the
pointer converts the type of pointer to that pointing to a single
object of the array.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu-defs.h
===================================================================
--- linux.orig/include/linux/percpu-defs.h	2013-08-22 13:39:04.000000000 -0500
+++ linux/include/linux/percpu-defs.h	2013-08-22 13:41:15.333140537 -0500
@@ -22,9 +22,12 @@
  * Macro which verifies @ptr is a percpu pointer without evaluating
  * @ptr.  This is to be used in percpu accessors to verify that the
  * input parameter is a percpu pointer.
+ *
+ * + 0 is required in order to convert the pointer type from a
+ * potential array type to a pointer to a single item of the array.
  */
 #define __verify_pcpu_ptr(ptr)	do {					\
-	const void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
+	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
 	(void)__vpp_verify;						\
 } while (0)
 

