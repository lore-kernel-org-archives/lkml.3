Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLaPWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:22:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaLaPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:49 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 1/8] ARM64: Move BRK opcodes defines from kprobes.h to insn.h
Date: Wed, 31 Dec 2014 20:51:17 +0530
Message-Id: <5beb1ff58d4928a873be5e898b62d8cc2003ec7c.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its better to keep all BRK opcodes used by kprobes and uprobes at one
place. Therefore move these defines to asm/insn.h.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/include/asm/insn.h | 6 ++++++
 arch/arm64/kernel/kprobes.h   | 7 +------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index e2ff32a93b5c..87fa48746806 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -23,6 +23,12 @@
 /* A64 instructions are always 32 bits. */
 #define	AARCH64_INSN_SIZE		4
 
+/* BRK opcodes with ESR encoding  */
+#define BRK64_ESR_MASK		0xFFFF
+#define BRK64_ESR_KPROBES	0x0004
+#define BRK64_OPCODE_KPROBES	0xD4200080	/* "brk 0x4" */
+#define ARCH64_NOP_OPCODE	0xD503201F
+
 #ifndef __ASSEMBLY__
 /*
  * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
diff --git a/arch/arm64/kernel/kprobes.h b/arch/arm64/kernel/kprobes.h
index 93c54b4972f9..a1140971b045 100644
--- a/arch/arm64/kernel/kprobes.h
+++ b/arch/arm64/kernel/kprobes.h
@@ -15,12 +15,7 @@
 
 #ifndef _ARM_KERNEL_KPROBES_H
 #define _ARM_KERNEL_KPROBES_H
-
-/* BRK opcodes with ESR encoding  */
-#define BRK64_ESR_MASK		0xFFFF
-#define BRK64_ESR_KPROBES	0x0004
-#define BRK64_OPCODE_KPROBES	0xD4200080	/* "brk 0x4" */
-#define ARCH64_NOP_OPCODE	0xD503201F
+#include <asm/insn.h>
 
 #define JPROBES_MAGIC_NUM	0xa5a5a5a5a5a5a5a5
 
-- 
2.1.0

