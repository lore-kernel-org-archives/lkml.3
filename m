Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3HZUSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:18:01 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:24175 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab3HZUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:17:57 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 16:17:57 EDT
Message-Id: <00000140bc3de2f7-5d54a0a9-8798-49c8-b083-15074179a4cc-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:08:27 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 02/31] percpu: Make __verify_pcu_ptr handle per cpu pointers to arrays
References: <20130826200843.526699195@linux.com>
X-SES-Outgoing: 199.127.232.35
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
 

