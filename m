Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3K1K1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:27:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48484 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3K1K1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:27:01 -0500
X-AuditID: cbfee691-b7f666d0000048b0-de-52971a73fd46
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
Cc: cpgs@samsung.com, linux@arm.linux.org.uk, a.anurag@samsung.com,
        naveen.sel@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        naveenkrishna.ch@gmail.com, anurag19aggarwal@gmail.com,
        narendra.m1@samsung.com, poorva.s@samsung.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        catalin.marinas@arm.com
Subject: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow in
 unwind_exec_insn Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
Date: Thu, 28 Nov 2013 15:57:19 +0530
Message-id: <1385634439-24554-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkULdYanqQwdGNqhaPL7SyWizZtpnV
	4v60b+wW75f1MFq8PKRp0TR3D6PFpsfXWC0u75rDZnH7Mq/FhLl/mS2Wnj/DbPFt+mJWi0Xb
	/jNbTD/2l83i1IOnLBaf569ltXj58QSLg6DHmnlrGD1amnvYPHbOusvucefaHjaPzUvqPfq2
	rGL0+LxJLoA9issmJTUnsyy1SN8ugSuj7/x99oL74hU/Zns3MJ4U6mLk5JAQMJGYu7GJBcIW
	k7hwbz1bFyMXh5DAUkaJ5S8/sMIUPXrTzgiRmM4ocfXxHRYIp51JovPdFDaQKjYBHYlXO9qZ
	QGwRAVuJpxtugXUwC3xmkjh45S1YkbDANEaJSSuCQGwWAVWJhr2PweK8Ai4SE38/BZrKAbRO
	QWLOJBuIzdfYJd53JkCUC0h8m3wIqkRWYtMBZogSSYmDK26wTGAUXMDIsIpRNLUguaA4Kb3I
	VK84Mbe4NC9dLzk/dxMjME5O/3s2cQfj/QPWhxiTgcZNZJYSTc4HxlleSbyhsZmRhamJqbGR
	uaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBud8ure6WfuXqdrfiSaiXt
	R3knt2lu5K4Vm7HzEec5xmiLHT+XOXWt/fr2ikOKc5rj57MeOmem/TJZK3Ls/XQ56av37MU2
	SH3Tft7HxuQZX13pcftiQ+mSGX+CmvUz/e4XM32OmHxoc25gl97f1Wm734lKL4jml9r1+q32
	qfSU+vczdtm/nFinxFKckWioxVxUnAgAlPwATakCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd1iqelBBotfSFs8vtDKarFk22ZW
	i/vTvrFbvF/Ww2jx8pCmRdPcPYwWmx5fY7W4vGsOm8Xty7wWE+b+ZbZYev4Ms8W36YtZLRZt
	+89sMf3YXzaLUw+eslh8nr+W1eLlxxMsDoIea+atYfRoae5h89g56y67x51re9g8Ni+p9+jb
	sorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRef
	AF23zBygB5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGX3n77MX3Bev
	+DHbu4HxpFAXIyeHhICJxKM37YwQtpjEhXvr2boYuTiEBKYzSlx9fIcFwmlnkuh8N4UNpIpN
	QEfi1Y52JhBbRMBW4umGW4wgRcwCn5kkDl55C1YkLDCNUWLSiiAQm0VAVaJh72OwOK+Ai8TE
	30+BpnIArVOQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwXH4THoH46oG
	i0OMAhyMSjy8EjrTgoRYE8uKK3MPMUpwMCuJ8DZzTA8S4k1JrKxKLcqPLyrNSS0+xJgMtHwi
	s5Rocj4wReSVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Ob
	9OaIpJdsbaoedWYv9Ltmc+jrlcbmbua5t4nZQGPZjsvf+QMfRr5c+VVa116lQ/apzxeLgw+c
	HHRnWAfeO3br7N76A9b+soWquftyXYxc1PgnMzUHO7ucCI0+87+YrVhsX4y5wfn1O6d1Nul3
	fbx84HfoC/HnCyaabJz/oM395XeDKqu74kosxRmJhlrMRcWJALd0ZBUHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While executing some unwind instructions stack overflow can cause a data abort
when area beyond stack is not mapped to physical memory.

To prevent the data abort check whether it is possible to execute
these instructions before unwinding the stack
---
 arch/arm/kernel/unwind.c |   59 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..3777cd7 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -49,6 +49,8 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 
+#define TOTAL_REGISTERS 16
+
 /* Dummy functions to avoid linker complaints */
 void __aeabi_unwind_cpp_pr0(void)
 {
@@ -66,7 +68,7 @@ void __aeabi_unwind_cpp_pr2(void)
 EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
 
 struct unwind_ctrl_block {
-	unsigned long vrs[16];		/* virtual register set */
+	unsigned long vrs[TOTAL_REGISTERS];	/* virtual register set */
 	const unsigned long *insn;	/* pointer to the current instructions word */
 	int entries;			/* number of entries left to interpret */
 	int byte;			/* current byte number in the instructions word */
@@ -235,6 +237,58 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	return ret;
 }
 
+/* check whether there is enough space on stack to execute instructions
+   that can cause a data abort*/
+static int unwind_check_insn(struct unwind_ctrl_block *ctrl, unsigned long insn)
+{
+	unsigned long high, low;
+	int required_stack = 0;
+
+	low = ctrl->vrs[SP];
+	high = ALIGN(low, THREAD_SIZE);
+
+	/* check whether we have enough space to extract
+	atleast one set of registers*/
+	if ((high - low) > TOTAL_REGISTERS)
+		return URC_OK;
+
+	if ((insn & 0xf0) == 0x80) {
+		unsigned long mask;
+		insn = (insn << 8) | unwind_get_byte(ctrl);
+		mask = insn & 0x0fff;
+		if (mask == 0) {
+			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
+				insn);
+			return -URC_FAILURE;
+		}
+		while (mask) {
+			if (mask & 1)
+				required_stack++;
+			mask >>= 1;
+		}
+	} else if ((insn & 0xf0) == 0xa0) {
+		required_stack += insn & 7;
+		required_stack +=  (insn & 0x80) ? 1 : 0;
+	} else if (insn == 0xb1) {
+		unsigned long mask = unwind_get_byte(ctrl);
+		if (mask == 0 || mask & 0xf0) {
+			pr_warning("unwind: Spare encoding %04lx\n",
+				(insn << 8) | mask);
+			return -URC_FAILURE;
+		}
+		while (mask) {
+			if (mask & 1)
+				required_stack++;
+			mask >>= 1;
+		}
+	}
+
+	if ((high - low) < required_stack)
+		return -URC_FAILURE;
+
+	return URC_OK;
+}
+
 /*
  * Execute the current unwind instruction.
  */
@@ -244,6 +298,9 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 
 	pr_debug("%s: insn = %08lx\n", __func__, insn);
 
+	if (unwind_check_insn(ctrl, insn) < 0)
+		return -URC_FAILURE;
+
 	if ((insn & 0xc0) == 0x00)
 		ctrl->vrs[SP] += ((insn & 0x3f) << 2) + 4;
 	else if ((insn & 0xc0) == 0x40)
-- 
1.7.0.4

