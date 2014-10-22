Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaJVGkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:40:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10429 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaJVGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:39:59 -0400
X-AuditID: cbfee691-f79b86d000004a5a-94-5447513d577b
Date: Wed, 22 Oct 2014 06:39:57 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20141022063518502@eunb.song
Msgkey: 20141022063518502@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141022063518502@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1669712409.167661413959996217.JavaMail.weblogic@epmlwas02b>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsVy+t8zTV3bQPcQg7VPxC0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmND06w1KwSrTi659+9gbGByJdjJwcQgIqEi3/vzOC2BICJhIvnp+B
	ssUkLtxbz9bFyAVUs4xR4uKqVewwRRsmn2WHSMxhlJi3ohUswSKgKrHhywcmEJtNQFvix4Gr
	zCC2sICLxOv23WBxEQEZiaWfroBtYBZwl3j76TgzxBXyEpNPXwabwysgKHFy5hOWLkYOoGVK
	ErO3sEKElSUW7/wAdZyExKzpF1ghbF6JGe1PWSBsOYlpX9cwQ9jSEudnbYB7ZvH3x1Bxfolj
	t3cwQdgCElPPHISqUZe41PQWyuaTWLPwLdRMQYnT17qZYXbd3zKXCeaGrS1PWCFeUZSY0v2Q
	HcLWkvjyYx8bqldAbA+J4+tmM4PCTUJgIofEt0WP2ScwKs1CUjcLyaxZSGYhq1nAyLKKUTS1
	ILmgOCm9yBQ5ujcxQlLhxB2M9w9YH2IU4GBU4uF1YHMPEWJNLCuuzD3EmAyMponMUqLJ+cCE
	m1cSb2hsZmRhamJqbGRuaYYhbGJqYWFihENYSZxXR/pnsJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQZG16+KgtnrltYxHzhWaW5bfrbc5s6taAXe2Q8WiJguNf0xJeVP5x4FjU8LDUOkZK8s
	U59iv9+ihN3YIn5a95/sxap/jlyV/RT407m1ZcHjvebyfrIiyp8fnJW2aFW7dWH9sa8CzZwX
	Czhfqq/pTLVedbF0frtNxZv3nR8/Xnog5p/G2XeiN3+3EktxRqKhFnNRcSIAsr03+64DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t/tPl3bQPcQgzm7hC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	RtOjMywFq0Qrvv7pZ29gfCDSxcjJISSgItHy/zsjiC0hYCKxYfJZdghbTOLCvfVsXYxcQDVz
	GCXmrWgFS7AIqEps+PKBCcRmE9CW+HHgKjOILSzgIvG6fTdYXERARmLppytgQ5kF3CXefjrO
	DLFMXmLy6ctgc3gFBCVOznzC0sXIAbRMSWL2FlaIsLLE4p0foO6RkJg1/QIrhM0rMaP9KQuE
	LScx7esaZghbWuL8rA2MMDcv/v4YKs4vcez2DiYIW0Bi6pmDUDXqEpea3kLZfBJrFr6Fmiko
	cfpaNzPMrvtb5jLB3LC15QkrxCuKElO6H7JD2FoSX37sY0P1CojtIXF83WzmCYyys5CkZiFp
	n4WkHVnNAkaWVYyiqQXJBcVJ6RWGesWJucWleel6yfm5mxjBqejZwh2MX85bH2IU4GBU4uF1
	YHMPEWJNLCuuzD3EKMHBrCTC22cBFOJNSaysSi3Kjy8qzUktPsRoCoy0icxSosn5wDSZVxJv
	aGxgbGhoaW5gamhkoSTOe/dmUpCQQHpiSWp2ampBahFMHxMHp1QDo+X7kLDgkKr3IsqZLumJ
	nqVnp1y91f1SjP/rComGXbWKu5Nez7xmrlejLmC889NOPqbDe6+UG09dqOOhXPzi/AHpLykC
	asfELf+c+n5T6krSXYNtJ5cassm/8Vp2bvtutUVBhUlbbJv4+5S3xpawnDxSsOvH0UPi2fsU
	o93suzofcsxQ3PtwhxJLcUaioRZzUXEiALXDlFhbAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9M6e8Qp004769


Currently, arch_trigger_all_cpu_backtrace() is defined in only x86 and sparc which has nmi interrupt.
But in case of softlockup not a hardlockup, it could be possible to dump backtrace of all cpus. and this could be helpful for debugging.

for example, if system has 2 cpus.

	CPU 0				CPU 1
 acquire read_lock()

				try to do write_lock()

 ,,,
 missing read_unlock()

In this case, softlockup will occur becasuse CPU 0 does not call read_unlock().
And dump_stack() print only backtrace for "CPU 0". If CPU1's backtrace is printed it's very helpful.

This patch adds arch_trigger_all_cpu_backtrace() for mips architecture.

Maybe someone make better patch than this. I just suggest the idea.
---
 arch/mips/include/asm/irq.h |    3 +++
 arch/mips/kernel/process.c  |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 39f07ae..5a4e1bb 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -48,4 +48,7 @@ extern int cp0_compare_irq;
 extern int cp0_compare_irq_shift;
 extern int cp0_perfcount_irq;
 
+void arch_trigger_all_cpu_backtrace(bool);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+
 #endif /* _ASM_IRQ_H */
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 636b074..9f51d3d 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -42,6 +42,7 @@
 #include <asm/isadep.h>
 #include <asm/inst.h>
 #include <asm/stacktrace.h>
+#include <asm/irq_regs.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 void arch_cpu_idle_dead(void)
@@ -532,3 +533,20 @@ unsigned long arch_align_stack(unsigned long sp)
 
 	return sp & ALMASK;
 }
+
+static void arch_dump_stack(void *info)
+{
+	struct pt_regs *regs;  
+	
+	regs = get_irq_regs();
+
+	if(regs)
+		show_regs(regs);
+
+	dump_stack();
+}
+
+void arch_trigger_all_cpu_backtrace(bool include_self)
+{
+	smp_call_function(arch_dump_stack, NULL, 1);
+}
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
