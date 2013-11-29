Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3K2Je4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:34:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45987 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3K2Jev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:34:51 -0500
X-AuditID: cbfee691-b7f666d0000048b0-57-52985fb9ff10
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
Cc: cpgs@samsung.com, linux@arm.linux.org.uk, a.anurag@samsung.com,
        naveen.sel@samsung.com, ashish.kalra@samsung.com,
        narendra.m1@samsung.com, poorva.s@samsung.com, mohammad.a2@samsung.com,
        rajat.suri@samsung.com, naveenkrishna.ch@gmail.com,
        anurag19aggarwal@gmail.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, nico@linaro.org, catalin.marinas@arm.com
Subject: [PATCH V2] ARM : unwinder : Prevent data abort due to stack overflow
 while executing unwind instructions Signed-off-by: Anurag Aggarwal
 <a.anurag@samsung.com>
Date: Fri, 29 Nov 2013 15:04:31 +0530
Message-id: <1385717671-28953-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWyRsSkRHdn/Iwgg1dNohaPL7SyWizZtpnV
	4v60b+wW75f1MFq8PKRp0TR3D6PFpsfXWC0u75rDZnH7Mq/FhLl/mS2Wnj/DbPFt+mJWi0Xb
	/jNbTD/2l83i1IOnLBaf569ltXj58QSLg6DHmnlrGD1amnvYPHbOusvucefaHjaPzUvqPfq2
	rGL0+LxJLoA9issmJTUnsyy1SN8ugStjVcMf5oKHZhUN1+waGJu1uhg5OSQETCSOPdnDCmGL
	SVy4t56ti5GLQ0hgKaPEj/nLmWCKem5MYIdILGKUWLCwH8ppZ5L4dXobWBWbgI7Eqx3tYLaI
	gK3E0w23GEGKmAU+M0ksW3YOzBEWWM0o8X/vRrAqFgFViY/zjoAt5xVwkdi4eh9QEQfQPgWJ
	OZNsQOolBG6xS9zoeMYCUS8g8W3yIRaIGlmJTQeYIc6TlDi44gbLBEbBBYwMqxhFUwuSC4qT
	0otM9YoTc4tL89L1kvNzNzECY+X0v2cTdzDeP2B9iDEZaNxEZinR5HxgrOWVxBsamxlZmJqY
	GhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2MuK7v94eXdh/+xCmgm
	WMlce/RUl2PDacsL82uji1gzAna9UphSxF1+/bswxyftzc6O70yFF591/9z3WFrjofYmKfdu
	p2Qt9tiCS5tf726LmuImsOOw9jmBdyxb7FtO7xZKPn2i6n/Cx1ldzqpZUzs25jG8qBS79Ged
	S47Hq/InEzlMHrP8rlRiKc5INNRiLipOBABfAUJFqwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd2d8TOCDI7e47J4fKGV1WLJts2s
	FvenfWO3eL+sh9Hi5SFNi6a5exgtNj2+xmpxedccNovbl3ktJsz9y2yx9PwZZotv0xezWiza
	9p/ZYvqxv2wWpx48ZbH4PH8tq8XLjydYHAQ91sxbw+jR0tzD5rFz1l12jzvX9rB5bF5S79G3
	ZRWjx+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+
	AbpumTlADygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM1Y1/GEueGhW
	0XDNroGxWauLkZNDQsBEoufGBHYIW0ziwr31bF2MXBxCAosYJRYs7GeHcNqZJH6d3sYEUsUm
	oCPxakc7mC0iYCvxdMMtRpAiZoHPTBLLlp0Dc4QFVjNK/N+7EayKRUBV4uO8I6wgNq+Ai8TG
	1fuAijiA9ilIzJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Eh8Jr2DcVWD
	xSFGAQ5GJR7eFd3Tg4RYE8uKK3MPMUpwMCuJ8P4qAgrxpiRWVqUW5ccXleakFh9iTAZaPpFZ
	SjQ5H5gk8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0eB0
	pKHPy2vcFUs23erc47DrGXOr2ifBHeZTes/MNWZdKOa68/Wce4zdd/499djzapdYyAH5rJtP
	pzvd45TrM2ZmXvRxksD6LZcFOv1W/ViVrLZSWzuyWix52YMbytPrYtf8dnj/Y1OO08oml/Xv
	dhYfnJl0/HEV/2zPPvdTLdai+Q/Vq77kvlRiKc5INNRiLipOBADihv3qCAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While unwinding backtrace, stack overflow is possible. This stack overflow can sometimes
lead to data abort in system if the area after stack is not mapped to physical memory.

To prevent this problem from happening execute the instructions that can cause data
abort in there seperate functions instead of unwind_exec_insn, where a check for there
feasibility is made first.
---
 arch/arm/kernel/unwind.c |  197 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 148 insertions(+), 49 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..150e0fc 100644
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
@@ -235,6 +237,148 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	return ret;
 }
 
+static int unwind_exec_insn_0x80(struct unwind_ctrl_block *ctrl,
+				unsigned long insn)
+{
+	unsigned long high, low;
+	unsigned long mask;
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int load_sp, reg = 4;
+
+	low = ctrl->vrs[SP];
+	high = ALIGN(low, THREAD_SIZE);
+
+	insn = (insn << 8) | unwind_get_byte(ctrl);
+	mask = insn & 0x0fff;
+	if (mask == 0) {
+		pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
+			insn);
+		return -URC_FAILURE;
+	}
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if ((high - low) < TOTAL_REGISTERS) {
+		unsigned long mask_copy = mask;
+		int required_stack = 0;
+
+		while (mask_copy) {
+			if (mask_copy & 1)
+				required_stack++;
+			mask_copy >>= 1;
+		}
+
+		if ((high - low) < required_stack)
+			return -URC_FAILURE;
+	}
+
+	load_sp = mask & (1 << (13 - 4));
+	while (mask) {
+		if (mask & 1)
+			ctrl->vrs[reg] = *vsp++;
+		mask >>= 1;
+		reg++;
+	}
+	if (!load_sp)
+		ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
+static int unwind_exec_insn_0xa0(struct unwind_ctrl_block *ctrl,
+				unsigned long insn)
+{
+	unsigned long high, low;
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg;
+
+	low = ctrl->vrs[SP];
+	high = ALIGN(low, THREAD_SIZE);
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if ((high-low) < TOTAL_REGISTERS) {
+		int required_stack;
+
+		required_stack = insn & 7;
+		required_stack += (insn & 0x80) ? 1 : 0;
+
+		if ((high-low) < required_stack)
+			return -URC_FAILURE;
+	}
+
+	/* pop R4-R[4+bbb] */
+	for (reg = 4; reg <= 4 + (insn & 7); reg++)
+		ctrl->vrs[reg] = *vsp++;
+	if (insn & 0x80)
+		ctrl->vrs[14] = *vsp++;
+	ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
+static int unwind_exec_insn_0xb1(struct unwind_ctrl_block *ctrl,
+				unsigned long insn)
+{
+	unsigned long high, low;
+	unsigned long mask = unwind_get_byte(ctrl);
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg = 0;
+
+	if (mask == 0 || mask & 0xf0) {
+		pr_warning("unwind: Spare encoding %04lx\n",
+			(insn << 8) | mask);
+		return -URC_FAILURE;
+	}
+
+	low = ctrl->vrs[SP];
+	high = ALIGN(low, THREAD_SIZE);
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if ((high-low) < TOTAL_REGISTERS) {
+		unsigned long mask_copy = mask;
+		int required_stack = 0;
+
+		while (mask_copy) {
+			if (mask_copy & 1)
+				required_stack++;
+			mask_copy >>= 1;
+		}
+		if ((high-low) < required_stack)
+			return -URC_FAILURE;
+	}
+
+	/* pop R0-R3 according to mask */
+	while (mask) {
+		if (mask & 1)
+			ctrl->vrs[reg] = *vsp++;
+		mask >>= 1;
+		reg++;
+	}
+	ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
 /*
  * Execute the current unwind instruction.
  */
@@ -249,65 +393,20 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 	else if ((insn & 0xc0) == 0x40)
 		ctrl->vrs[SP] -= ((insn & 0x3f) << 2) + 4;
 	else if ((insn & 0xf0) == 0x80) {
-		unsigned long mask;
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int load_sp, reg = 4;
-
-		insn = (insn << 8) | unwind_get_byte(ctrl);
-		mask = insn & 0x0fff;
-		if (mask == 0) {
-			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
-				   insn);
-			return -URC_FAILURE;
-		}
-
-		/* pop R4-R15 according to mask */
-		load_sp = mask & (1 << (13 - 4));
-		while (mask) {
-			if (mask & 1)
-				ctrl->vrs[reg] = *vsp++;
-			mask >>= 1;
-			reg++;
-		}
-		if (!load_sp)
-			ctrl->vrs[SP] = (unsigned long)vsp;
+		return unwind_exec_insn_0x80(ctrl, insn);
 	} else if ((insn & 0xf0) == 0x90 &&
 		   (insn & 0x0d) != 0x0d)
 		ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
 	else if ((insn & 0xf0) == 0xa0) {
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg;
-
-		/* pop R4-R[4+bbb] */
-		for (reg = 4; reg <= 4 + (insn & 7); reg++)
-			ctrl->vrs[reg] = *vsp++;
-		if (insn & 0x80)
-			ctrl->vrs[14] = *vsp++;
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		 return unwind_exec_insn_0xa0(ctrl, insn);
 	} else if (insn == 0xb0) {
 		if (ctrl->vrs[PC] == 0)
 			ctrl->vrs[PC] = ctrl->vrs[LR];
 		/* no further processing */
 		ctrl->entries = 0;
 	} else if (insn == 0xb1) {
-		unsigned long mask = unwind_get_byte(ctrl);
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg = 0;
 
-		if (mask == 0 || mask & 0xf0) {
-			pr_warning("unwind: Spare encoding %04lx\n",
-			       (insn << 8) | mask);
-			return -URC_FAILURE;
-		}
-
-		/* pop R0-R3 according to mask */
-		while (mask) {
-			if (mask & 1)
-				ctrl->vrs[reg] = *vsp++;
-			mask >>= 1;
-			reg++;
-		}
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		 return unwind_exec_insn_0xb1(ctrl, insn);
 	} else if (insn == 0xb2) {
 		unsigned long uleb128 = unwind_get_byte(ctrl);
 
-- 
1.7.0.4

