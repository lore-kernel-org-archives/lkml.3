Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaCLWjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:39:54 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37040 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCLWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:39:51 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, Paul Bolle <pebolle@tiscali.nl>,
        Huacai Chen <chenhc@lemote.com>, Andreas Barth <aba@ayous.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH RESEND 1/2] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
Date: Thu, 13 Mar 2014 00:41:06 +0200
Message-Id: <1394664067-17712-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi>
References: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
should apparently be replaced with CONFIG_64BIT.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
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
index 6b97495..58e50cb 100644
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
1.9.0

