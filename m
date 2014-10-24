Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaJXAsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:48:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58554 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaJXAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:48:35 -0400
X-AuditID: cbfee68d-f79296d000004278-ff-5449a1e1f087
Date: Fri, 24 Oct 2014 00:48:33 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH resend] mips: add arch_trigger_all_cpu_backtrace() function
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20141024004653417@eunb.song
Msgkey: 20141024004653417@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141024004653417@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1096029731.11011414111712740.JavaMail.weblogic@epmlwas01c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsVy+t8zTd2HCz1DDK6tMLO4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqYMa1vAlvBHdGKVzfb2BoYJ4h2MXJyCAmoSLT8/84IYksImEg0tC5m
	hrDFJC7cW8/WxcgFVLOMUeLgjHtMMEW/376CSsxhlFg8YylYgkVAVeLVxomsIDabgLbEjwNX
	wSYJC/hI7F42CaxGREBf4v+5t+wgNrNAjUT338WMEFfIS0w+fRkszisgKHFy5hOWLkYOoGVK
	Eg/3+kCElSU2XfzEAnGDhMSs6RdYIWxeiRntT6HichLTvq6BekBa4vysDYwwzyz+/hgqzi9x
	7PYOqF8EJKaeOcgIsUpd4tkvR4gwn8SahW+hRgpKnL7WzQyz6v6WuUwwJ2xtecIK8YmixJTu
	h1BfaUl8+bGPDdUnILa7xIX/e1lBwSYhMJVDonPmRPYJjEqzkNTNQjJrFpJZyGoWMLKsYhRN
	LUguKE5KLzJEju1NjJBE2LuD8fYB60OMAhyMSjy8N2Z4hgixJpYVV+YeYkwGxtJEZinR5Hxg
	us0riTc0NjOyMDUxNTYytzTDEDYxtbAwMcIhrCTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD4yLTI6K2ih8etV1fErH3Fsd2q+t15Tf49CyWfBZkrvi4qPOE2/N2npWvZL0s2BQC
	a5MnTW3vXJg8RfvR9z3vS4ulWkzkc9b8OjnhFkPPqcPL/m25WWIY9JM5+dEcX9+W1NRnt71L
	5S6n7o87GPNBnffYnPXmL+ozir59vascFukw52fzxl93NimxFGckGmoxFxUnAgAtyDpurQMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t/tPt2HCz1DDC41Gltc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jGl9E9gK7ohWvLrZxtbAOEG0i5GTQ0hARaLl/3dGEFtCwETi99tXbBC2mMSFe+uBbC6gmjmM
	EotnLGUCSbAIqEq82jiRFcRmE9CW+HHgKjOILSzgI7F72SSwGhEBfYn/596yg9jMAjUS3X8X
	M0Isk5eYfPoyWJxXQFDi5MwnLF2MHEDLlCQe7vWBCCtLbLr4iQXiBgmJWdMvsELYvBIz2p9C
	xeUkpn1dwwxhS0ucn7WBEebmxd8fQ8X5JY7d3sEEYQtITD1zkBFilbrEs1+OEGE+iTUL30KN
	FJQ4fa2bGWbV/S1zmWBO2NryhBXiE0WJKd0Pob7SkvjyYx8bqk9AbHeJC//3sk5glJ2FJDUL
	SfssJO3IahYwsqxiFE0tSC4oTkqvMNYrTswtLs1L10vOz93ECE5EzxbvYPx/3voQowAHoxIP
	740ZniFCrIllxZW5hxglOJiVRHiPdwKFeFMSK6tSi/Lji0pzUosPMZoC42wis5Rocj4wSeaV
	xBsaGxgbGlqaG5gaGlkoifPG30oKEhJITyxJzU5NLUgtgulj4uCUamCsCDy4iKmJwfj9Bvdl
	wfdmTdgpebeuNlrA7+tG8YDUXfHbnF4fDSldWpb05brz4k0Tfmx0OJ7t/4e54/lcBi9/E5V5
	xS92bCvIyFnYvV3qUhn/Bv/bB9LSmlU9V0wQbm5hVluf18rGOPmG/54s11/Wbe+4y87c7F/o
	tnnHbx9ua3Gt3aoyIm1KLMUZiYZazEXFiQDhhHSMWgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9O0mgxh019496


Currently, arch_trigger_all_cpu_backtrace() is defined in only x86 and sparc which has nmi interrupt.
But in case of softlockup not a hadrlockup, it could be possible to dump backtrace of all cpus.
And this could be helpful for debugging.

for example, if system has 2 cpus.

	CPU 0				CPU 1
 acquire read_lock()

				try to do write_lock()

 ,,,
 missing read_unlock()

In this case, dump_stack() print only backtrace for "CPU 0".
If CPU1's calltrace is printed it's very helpful.

This patch adds arch_trigger_all_cpu_backtrace() for mips architecture.
And this enables when softlockup_all_cpu_backtrace is equalt to 1 and
softlock is occurred to dump all cpu's backtrace.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
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
index 636b074..5801f21 100644
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
+	if (regs)
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
