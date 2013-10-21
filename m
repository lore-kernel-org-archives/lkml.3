Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3JULZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:25:46 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54216 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3JULZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:25:45 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] percpu: remove this_cpu_xor() implementation
Date: Mon, 21 Oct 2013 13:25:36 +0200
Message-Id: <1382354737-59872-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102111-4966-0000-0000-0000073EA543
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not a single user in the whole kernel.
Besides that this_cpu_xor() is broken anyway since it gets
translated to this_cpu_or() (see __pcpu_size_call() line).

So instead of fixing an unused definition just remove it.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/percpu.h | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index cc88172..fd6ffe4 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -375,22 +375,6 @@ do {									\
 # define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif
 
-#ifndef this_cpu_xor
-# ifndef this_cpu_xor_1
-#  define this_cpu_xor_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_2
-#  define this_cpu_xor_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_4
-#  define this_cpu_xor_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_8
-#  define this_cpu_xor_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-#endif
-
 #define _this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	typeof(pcp) ret__;						\
@@ -629,22 +613,6 @@ do {									\
 # define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_xor
-# ifndef __this_cpu_xor_1
-#  define __this_cpu_xor_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_2
-#  define __this_cpu_xor_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_4
-#  define __this_cpu_xor_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_8
-#  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
-#endif
-
 #define __this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	__this_cpu_add(pcp, val);					\
-- 
1.8.3.4

