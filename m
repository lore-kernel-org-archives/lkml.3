Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaBINc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:32:28 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54195 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbaBINc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:32:26 -0500
Message-ID: <1391952745.25424.6.camel@x220>
Subject: [PATCH] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 14:32:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:32:25.0570 (UTC) FILETIME=[5EAEB420:01CF259B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
should apparently be replaced with CONFIG_64BIT.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

 arch/mips/include/asm/asmmacro.h | 4 ++--
 arch/mips/include/asm/fpu.h      | 2 +-
 arch/mips/kernel/r4k_fpu.S       | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/asmmacro.h b/arch/mips/include/asm/asmmacro.h
index 3220c93..69a9a22 100644
--- a/arch/mips/include/asm/asmmacro.h
+++ b/arch/mips/include/asm/asmmacro.h
@@ -106,7 +106,7 @@
 	.endm
 
 	.macro	fpu_save_double thread status tmp
-#if defined(CONFIG_MIPS64) || defined(CONFIG_CPU_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	sll	\tmp, \status, 5
 	bgez	\tmp, 10f
 	fpu_save_16odd \thread
@@ -159,7 +159,7 @@
 	.endm
 
 	.macro	fpu_restore_double thread status tmp
-#if defined(CONFIG_MIPS64) || defined(CONFIG_CPU_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	sll	\tmp, \status, 5
 	bgez	\tmp, 10f				# 16 register mode?
 
diff --git a/arch/mips/include/asm/fpu.h b/arch/mips/include/asm/fpu.h
index cfe092f..f80a07e 100644
--- a/arch/mips/include/asm/fpu.h
+++ b/arch/mips/include/asm/fpu.h
@@ -57,7 +57,7 @@ static inline int __enable_fpu(enum fpu_mode mode)
 		return 0;
 
 	case FPU_64BIT:
-#if !(defined(CONFIG_CPU_MIPS32_R2) || defined(CONFIG_MIPS64))
+#if !(defined(CONFIG_CPU_MIPS32_R2) || defined(CONFIG_64BIT))
 		/* we only have a 32-bit FPU */
 		return SIGFPE;
 #endif
diff --git a/arch/mips/kernel/r4k_fpu.S b/arch/mips/kernel/r4k_fpu.S
index 253b2fb..841ffc2 100644
--- a/arch/mips/kernel/r4k_fpu.S
+++ b/arch/mips/kernel/r4k_fpu.S
@@ -35,9 +35,9 @@
 LEAF(_save_fp_context)
 	cfc1	t1, fcr31
 
-#if defined(CONFIG_64BIT) || defined(CONFIG_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
-#ifdef CONFIG_MIPS32_R2
+#ifdef CONFIG_CPU_MIPS32_R2
 	.set	mips64r2
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
@@ -148,9 +148,9 @@ LEAF(_save_fp_context32)
 LEAF(_restore_fp_context)
 	EX	lw t0, SC_FPC_CSR(a0)
 
-#if defined(CONFIG_64BIT) || defined(CONFIG_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
-#ifdef CONFIG_MIPS32_R2
+#ifdef CONFIG_CPU_MIPS32_R2
 	.set	mips64r2
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
-- 
1.8.5.3



