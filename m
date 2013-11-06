Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3KFJv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:51:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFJvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:51:54 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-a8-527a11380c54
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: cpgs@samsung.com, linux@arm.linux.org.uk, a.anurag@samsung.com,
        naveen.sel@samsung.com, narendra.m1@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        naveenkrishna.ch@gmail.com, anurag19aggarwal@gmail.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        catalin.marinas@arm.com
Subject: [PATCH] ARM: unwinder: Handle Stackoverflow in unwind_exec_insn
Date: Wed, 06 Nov 2013 15:20:48 +0530
Message-id: <1383731448-847-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSpGshWBVkMGmFlMXjC62sFku2bWa1
	eL+sh9Hi5SFNi02Pr7FaXN41h83i9mVeiwlz/zJbLD1/htni2/TFrBaLtv1ntph+7C+bxef5
	a1ktXn48weLA57Fm3hpGj5bmHjaPnbPusnvcubaHzWPzknqPvi2rGD0+b5ILYI/isklJzcks
	Sy3St0vgyuh+9o+lYIZYxaaDsQ2MDYJdjJwcEgImEhNvTmCFsMUkLtxbz9bFyMUhJLCUUaKl
	5Rc7TNG51XuhEosYJSY2fmGCcNqZJJ60TmcEqWIT0JF4taOdCcQWEdCQmNL1mB2kiFngIJPE
	zL5/YDuEBTwknhy4CDaWRUBV4uK0tWA2r4CTxPeZjSxdjBxA6xQk5kyyAemVEDjELrFs03Y2
	iHoBiW+TD0HVyEpsOsAMcZ2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7
	iREYC6f/PevbwXjzgPUhxmSgcROZpUST84GxlFcSb2hsZmRhamJqbGRuaUaasJI476KHSUFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGNVvboj5kz/vjdOV634b/5Vv+f+ya/m8X20pMb8u
	LnRjutGiYNX84u/Xxx9CU5kMow+UME3KvGb0YKH0+7cnazZbldVoXnWZZBXyYb/Kknr9SSEs
	t//6FTzrnCsVUuY5716t8B+lY/P9xJlDNrGE6+6S3L79bN0D3zWvG/hUV17JPvrgfskMZVsl
	luKMREMt5qLiRAC6tzPOmwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAV0Lwaogg/tNghaPL7SyWizZtpnV
	4v2yHkaLl4c0LTY9vsZqcXnXHDaL25d5LSbM/ctssfT8GWaLb9MXs1os2vaf2WL6sb9sFp/n
	r2W1ePnxBIsDn8eaeWsYPVqae9g8ds66y+5x59oeNo/NS+o9+rasYvT4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hiJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG97N/LAUzxCo2HYxtYGwQ7GLk5JAQMJE4
	t3ovG4QtJnHh3nogm4tDSGARo8TExi9MEE47k8ST1umMIFVsAjoSr3a0M4HYIgIaElO6HrOD
	FDELHGSSmNn3jxUkISzgIfHkwEV2EJtFQFXi4rS1YDavgJPE95mNLF2MHEDrFCTmTLKZwMi9
	gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwpD2T2sG4ssHiEKMAB6MSD2+CfGWQEGti
	WXFl7iFGCQ5mJRHeGq6qICHelMTKqtSi/Pii0pzU4kOMyUDLJzJLiSbnA5NAXkm8obGJmZGl
	kbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwiu//fWjNxL9r5JUqPx67tHGv
	rN8Xi19/59S9NDh+XnO2uf5W88vesy9ejXZUrc4zLti7+D2ruHZVxqqOuTXmni7Bwf9WNe0p
	meAuvb54003njdsuTfLJ09JTclLWmWbFItYX1mu158fiLWdvTWR//mKWiL1a5J62+mnKmVaS
	R0WYdh785lkYrsRSnJFoqMVcVJwIADa0+Of4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Altough stack overflow is expected in unwind_exec_insn, but in cases when area beyond stack is not mapped to physical memory this can cause data abort. 

To avoid above condition handle stack overflow in unwind_exec_insn by checking vsp pointer from top of stack 
Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
---
 arch/arm/kernel/unwind.c | 23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-) 
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c 
index 00df012..d8b8721 100644 
--- a/arch/arm/kernel/unwind.c 
+++ b/arch/arm/kernel/unwind.c 
@@ -241,6 +241,10 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 {
 	unsigned long insn = unwind_get_byte(ctrl); 
+	unsigned long high, low; 
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP]; 
+	low = ctrl->vrs[SP]; 
+	high = ALIGN(low, THREAD_SIZE);
 
 	pr_debug("%s: insn = %08lx\n", __func__, insn);
 
@@ -263,27 +267,27 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 
 		/* pop R4-R15 according to mask */
 		load_sp = mask & (1 << (13 - 4)); 
- 		while (mask) { 
+ 		while (mask && vsp < high) {
 			if (mask & 1)
 				ctrl->vrs[reg] = *vsp++;
 			mask >>= 1;
 			reg++;
 		}
- 		if (!load_sp) 
+ 		if (!load_sp && vsp < high)
 			ctrl->vrs[SP] = (unsigned long)vsp;
 	} else if ((insn & 0xf0) == 0x90 &&
 		   (insn & 0x0d) != 0x0d)
 		ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
 	else if ((insn & 0xf0) == 0xa0) { 
- 		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
 		int reg;

 		/* pop R4-R[4+bbb] */
-		for (reg = 4; reg <= 4 + (insn & 7); reg++)
+		for (reg = 4;  (reg <= 4 + (insn & 7)) && (vsp < high; reg++)
 			ctrl->vrs[reg] = *vsp++;
-		if (insn & 0x80)
+		if (insn & 0x80 && vsp < high)
 			ctrl->vrs[14] = *vsp++;
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		if (vsp < high)
+			ctrl->vrs[SP] = (unsigned long)vsp;
 	} else if (insn == 0xb0) {
 		if (ctrl->vrs[PC] == 0)
 			ctrl->vrs[PC] = ctrl->vrs[LR];
@@ -301,13 +305,14 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		}
 
 		/* pop R0-R3 according to mask */
-		while (mask) {
+		while (mask && vsp < high) {
 			if (mask & 1)
 				ctrl->vrs[reg] = *vsp++;
 			mask >>= 1;
 			reg++;
 		}
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		if (vsp < high)
+			ctrl->vrs[SP] = (unsigned long)vsp;
 	} else if (insn == 0xb2) {
 		unsigned long uleb128 = unwind_get_byte(ctrl);
 
@@ -317,6 +322,8 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		return -URC_FAILURE;
 	}
 
+	if (vsp >= high)
+		return -URC_FAILURE;
 	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
 		 ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
 
-- 
