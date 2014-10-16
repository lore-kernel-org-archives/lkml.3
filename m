Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaJPOCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:02:31 -0400
Received: from afflict.kos.to ([92.243.29.197]:45272 "EHLO afflict.kos.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaJPOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:02:30 -0400
From: Riku Voipio <riku.voipio@linaro.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Riku Voipio <riku.voipio@linaro.org>
Subject: [PATCH] gcov: enable GCOV_PROFILE_ALL from ARCH Kconfigs
Date: Thu, 16 Oct 2014 17:02:22 +0300
Message-Id: <1413468142-32628-1-git-send-email-riku.voipio@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the suggestions from Andrew Morton and Stephen Rothwell,
Dont expand the ARCH list in kernel/gcov/Kconfig. Instead,
define a ARCH_HAS_GCOV_PROFILE_ALL bool which architectures
can enable.

set ARCH_HAS_GCOV_PROFILE_ALL on Architectures where it was
previously allowed + ARM64 which I tested.

Replaces earlier "gcov: add ARM64 to GCOV_PROFILE_ALL" patch.

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
---
 arch/arm/Kconfig        | 1 +
 arch/arm64/Kconfig      | 1 +
 arch/microblaze/Kconfig | 1 +
 arch/powerpc/Kconfig    | 1 +
 arch/s390/Kconfig       | 1 +
 arch/sh/Kconfig         | 1 +
 arch/x86/Kconfig        | 1 +
 kernel/gcov/Kconfig     | 5 ++++-
 8 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..6bcc559 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -5,6 +5,7 @@ config ARM
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ac9afde..3ac8bb1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,6 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 6feded3..0583778 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -1,5 +1,6 @@
 config MICROBLAZE
 	def_bool y
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 88eace4..7eca9f8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -128,6 +128,7 @@ config PPC
 	select HAVE_BPF_JIT if PPC64
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f2cf1f9..68b68d7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -65,6 +65,7 @@ config S390
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 244fb4c..6db486a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select PERF_USE_VMALLOC
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e8..083df48 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAS_FAST_MULTIPLIER
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_AOUT if X86_32
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index cf66c5c..c92e448 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -32,10 +32,13 @@ config GCOV_KERNEL
 	Note that the debugfs filesystem has to be mounted to access
 	profiling data.
 
+config ARCH_HAS_GCOV_PROFILE_ALL
+	def_bool n
+
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
+	depends on ARCH_HAS_GCOV_PROFILE_ALL
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
-- 
2.1.1

