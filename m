Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbaGORZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:25:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46518 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaGORCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:09 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 18/94] ARM: kprobes: Fix test code compilation errors for ARMv4 targets
Date: Tue, 15 Jul 2014 20:00:33 +0300
Message-Id: <1405443709-15288-18-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Medhurst <tixy@linaro.org>

Conditionally compile kprobes test cases for ARMv5 instructions to avoid
compilation errors with ARMv4 targets like:

/tmp/cc7Tx8ST.s:16740: Error: selected processor does not support ARM mode `clz r0,r0'

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/kernel/kprobes-test-arm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index e73f9cf..cb14242 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -218,6 +218,7 @@ void kprobe_arm_test_cases(void)
 	TEST_BB_R("bx	r",7,2f,"")
 	TEST_BF_R("bxeq	r",14,2f,"")
 
+#if __LINUX_ARM_ARCH__ >= 5
 	TEST_R("clz	r0, r",0, 0x0,"")
 	TEST_R("clzeq	r7, r",14,0x1,"")
 	TEST_R("clz	lr, r",7, 0xffffffff,"")
@@ -339,6 +340,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(__inst_arm(0xe16f02e1) " @ smultt pc, r1, r2")
 	TEST_UNSUPPORTED(__inst_arm(0xe16002ef) " @ smultt r0, pc, r2")
 	TEST_UNSUPPORTED(__inst_arm(0xe1600fe1) " @ smultt r0, r1, pc")
+#endif
 
 	TEST_GROUP("Multiply and multiply-accumulate")
 
@@ -561,6 +563,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED("ldrsht	r1, [r2], #48")
 #endif
 
+#if __LINUX_ARM_ARCH__ >= 5
 	TEST_RPR(  "strd	r",0, VAL1,", [r",1, 48,", -r",2,24,"]")
 	TEST_RPR(  "strccd	r",8, VAL2,", [r",13,0, ", r",12,48,"]")
 	TEST_RPR(  "strd	r",4, VAL1,", [r",2, 24,", r",3, 48,"]!")
@@ -597,6 +600,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(__inst_arm(0xe1efc3d0) "	@ ldrd r12, [pc, #48]!")
 	TEST_UNSUPPORTED(__inst_arm(0xe0c9f3d0) "	@ ldrd pc, [r9], #48")
 	TEST_UNSUPPORTED(__inst_arm(0xe0c9e3d0) "	@ ldrd lr, [r9], #48")
+#endif
 
 	TEST_GROUP("Miscellaneous")
 
@@ -1229,7 +1233,9 @@ void kprobe_arm_test_cases(void)
 	TEST_COPROCESSOR( "mrc"two"	0, 0, r0, cr0, cr0, 0")
 
 	COPROCESSOR_INSTRUCTIONS_ST_LD("",e)
+#if __LINUX_ARM_ARCH__ >= 5
 	COPROCESSOR_INSTRUCTIONS_MC_MR("",e)
+#endif
 	TEST_UNSUPPORTED("svc	0")
 	TEST_UNSUPPORTED("svc	0xffffff")
 
@@ -1289,7 +1295,9 @@ void kprobe_arm_test_cases(void)
 	TEST(	"blx	__dummy_thumb_subroutine_odd")
 #endif /* __LINUX_ARM_ARCH__ >= 6 */
 
+#if __LINUX_ARM_ARCH__ >= 5
 	COPROCESSOR_INSTRUCTIONS_ST_LD("2",f)
+#endif
 #if __LINUX_ARM_ARCH__ >= 6
 	COPROCESSOR_INSTRUCTIONS_MC_MR("2",f)
 #endif
-- 
1.7.10.4

