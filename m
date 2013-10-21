Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3JUL1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:27:04 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:41490 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3JUL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:27:02 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] x86: remove this_cpu_xor() implementation
Date: Mon, 21 Oct 2013 13:25:37 +0200
Message-Id: <1382354737-59872-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102111-8372-0000-0000-00000785D056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused x86 implementation of this_cpu_xor().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/x86/include/asm/percpu.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0da5200..604e13d 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -377,9 +377,6 @@ do {									\
 #define __this_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
 #define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
 #define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
@@ -399,9 +396,6 @@ do {									\
 #define this_cpu_or_1(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_or_2(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_or_4(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
@@ -446,7 +440,6 @@ do {									\
 #define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
@@ -456,7 +449,6 @@ do {									\
 #define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-- 
1.8.3.4

