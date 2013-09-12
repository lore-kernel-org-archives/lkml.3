Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3ILSzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3ILSzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:55:15 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rth@twiddle.net, vgupta@synopsys.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, geert@linux-m68k.org,
        monstr@monstr.eu, ralf@linux-mips.org, jejb@parisc-linux.org,
        benh@kernel.crashing.org, lethal@linux-sh.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, Mark Salter <msalter@redhat.com>
Subject: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
Date: Thu, 12 Sep 2013 14:53:58 -0400
Message-Id: <1379012038-31764-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove messy dependencies from PARPORT_PC by having it depend on one
Kconfig symbol (ARCH_MAY_HAVE_PC_PARPORT) and having architectures
which need it declare ARCH_MAY_HAVE_PC_PARPORT in arch/*/Kconfig.
New architectures are unlikely to need PARPORT_PC, so this avoids
having an ever growing list of architectures to exclude. Those
architectures which do declare ARCH_MAY_HAVE_PC_PARPORT in this
patch are the ones which have an asm/parport.h.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/alpha/Kconfig      | 3 +++
 arch/arc/Kconfig        | 3 +++
 arch/arm/Kconfig        | 3 +++
 arch/ia64/Kconfig       | 3 +++
 arch/m68k/Kconfig       | 4 ++++
 arch/microblaze/Kconfig | 3 +++
 arch/mips/Kconfig       | 3 +++
 arch/parisc/Kconfig     | 3 +++
 arch/powerpc/Kconfig    | 3 +++
 arch/sh/Kconfig         | 3 +++
 arch/sparc/Kconfig      | 4 ++++
 arch/tile/Kconfig       | 3 +++
 arch/unicore32/Kconfig  | 3 +++
 arch/x86/Kconfig        | 3 +++
 drivers/parport/Kconfig | 4 +---
 15 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 082d9b4..0f8fa2c 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -520,6 +520,9 @@ config EISA
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 68fcbb2..fb24bb2 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -70,6 +70,9 @@ config HAVE_LATENCYTOP_SUPPORT
 config NO_DMA
 	def_bool n
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b5eee26..5ded688 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -71,6 +71,9 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config ARM_HAS_SG_CHAIN
 	bool
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index a86a56d..3ae7dd3 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -126,6 +126,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
 	depends on BROKEN
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 821170e..dadea9a 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -35,6 +35,10 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	depends on ISA
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 3f6659c..00c3443 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -67,6 +67,9 @@ config LOCKDEP_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 71f15e7..e8d5d33 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -861,6 +861,9 @@ config FW_ARC
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config BOOT_RAW
 	bool
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index aa399a5..d2dcd1b 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -102,6 +102,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on BROKEN
 	default y
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6b7530f..e706eea 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -169,6 +169,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default !PPC_PSERIES || PCI
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config PPC_OF
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1018ed3..f49c057 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -143,6 +143,9 @@ config HAVE_LATENCYTOP_SUPPORT
 config ARCH_HAS_ILOG2_U32
 	def_bool n
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 1570ad2..493867e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -197,6 +197,10 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	depends on SPARC64 && PCI
+	def_bool y
+
 config EMULATED_CMPXCHG
 	bool
 	default y if SPARC32
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 932fa14..40c3988 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -88,6 +88,9 @@ config NEED_DMA_MAP_STATE
 config ARCH_HAS_DMA_SET_COHERENT_MASK
 	bool
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config LOCKDEP_SUPPORT
 	def_bool y
 
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 41bcc00..111df43 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -62,6 +62,9 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config ZONE_DMA
 	def_bool y
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30c40f0..aef54ff 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -180,6 +180,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 	depends on ISA_DMA_API
 
+config ARCH_MAY_HAVE_PC_PARPORT
+	def_bool y
+
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 70694ce..fa005a9 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -35,9 +35,7 @@ if PARPORT
 
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
-		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
-		!XTENSA && !CRIS && !H8300
+	depends on ARCH_MAY_HAVE_PC_PARPORT
 
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
-- 
1.8.3.1

