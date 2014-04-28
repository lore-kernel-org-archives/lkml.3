Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaD1VMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:12:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbaD1VLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:11:34 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org
Subject: [PATCH 1/3][RFC][v1] kconfig: Change COMMAND_LINE_SIZE to a kernel config option, which is now set per architecture.
Date: Mon, 28 Apr 2014 17:11:23 -0400
Message-Id: <66150aac47dbd32fd94ff93d13670b50c93cf3d0.1398287637.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1398287636.git.joseph.salisbury@canonical.com>
References: <cover.1398287636.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1398287636.git.joseph.salisbury@canonical.com>
References: <cover.1398287636.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having COMMAND_LINE_SIZE a kernel config option is a cleaner way to modify the value if needed. Currently defines need to be changed within the architecture specific header files.

The default COMMAND_LINE_SIZE for asm-generic is still set by a define in include/asm-generic/setup.h.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 arch/alpha/Kconfig                       | 6 ++++++
 arch/alpha/include/uapi/asm/setup.h      | 4 +++-
 arch/arc/Kconfig                         | 6 ++++++
 arch/arc/include/asm/setup.h             | 4 +++-
 arch/arm/Kconfig                         | 6 ++++++
 arch/arm/include/uapi/asm/setup.h        | 4 +++-
 arch/arm64/Kconfig                       | 6 ++++++
 arch/arm64/include/uapi/asm/setup.h      | 4 +++-
 arch/avr32/Kconfig                       | 6 ++++++
 arch/avr32/include/uapi/asm/setup.h      | 4 +++-
 arch/c6x/Kconfig                         | 6 ++++++
 arch/c6x/include/uapi/asm/setup.h        | 4 +++-
 arch/cris/Kconfig                        | 6 ++++++
 arch/cris/include/uapi/asm/setup.h       | 4 +++-
 arch/frv/Kconfig                         | 6 ++++++
 arch/frv/include/uapi/asm/setup.h        | 5 +++--
 arch/ia64/Kconfig                        | 6 ++++++
 arch/ia64/include/uapi/asm/setup.h       | 4 +++-
 arch/m32r/Kconfig                        | 6 ++++++
 arch/m32r/include/uapi/asm/setup.h       | 5 +++--
 arch/m68k/Kconfig                        | 6 ++++++
 arch/m68k/include/uapi/asm/setup.h       | 4 +++-
 arch/microblaze/Kconfig                  | 6 ++++++
 arch/microblaze/include/uapi/asm/setup.h | 4 +++-
 arch/mips/Kconfig                        | 6 ++++++
 arch/mips/include/uapi/asm/setup.h       | 5 +++--
 arch/mn10300/Kconfig                     | 6 ++++++
 arch/mn10300/include/uapi/asm/param.h    | 4 +++-
 arch/parisc/Kconfig                      | 6 ++++++
 arch/parisc/include/uapi/asm/setup.h     | 4 +++-
 arch/powerpc/Kconfig                     | 6 ++++++
 arch/powerpc/boot/ops.h                  | 5 ++++-
 arch/s390/Kconfig                        | 6 ++++++
 arch/s390/include/uapi/asm/setup.h       | 4 +++-
 arch/score/Kconfig                       | 6 ++++++
 arch/score/include/uapi/asm/setup.h      | 5 ++++-
 arch/sparc/Kconfig                       | 7 +++++++
 arch/sparc/include/uapi/asm/setup.h      | 7 ++-----
 arch/tile/Kconfig                        | 6 ++++++
 arch/tile/include/uapi/asm/setup.h       | 5 +++--
 arch/um/Kconfig.um                       | 6 ++++++
 arch/um/include/asm/setup.h              | 4 +++-
 arch/x86/Kconfig                         | 6 ++++++
 arch/x86/include/asm/setup.h             | 4 +++-
 arch/xtensa/Kconfig                      | 6 ++++++
 arch/xtensa/include/uapi/asm/setup.h     | 4 +++-
 include/uapi/asm-generic/setup.h         | 2 +-
 47 files changed, 210 insertions(+), 32 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b7ff9a3..42bd2e7 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -563,6 +563,12 @@ config HAVE_DEC_LOCK
 	depends on SMP
 	default y
 
+config COMMAND_LINE_SIZE
+	int "Maximum size of the command line"
+	default "256"
+	help
+	This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/alpha/include/uapi/asm/setup.h b/arch/alpha/include/uapi/asm/setup.h
index b50014b..f2956cc 100644
--- a/arch/alpha/include/uapi/asm/setup.h
+++ b/arch/alpha/include/uapi/asm/setup.h
@@ -1,7 +1,9 @@
 #ifndef __ALPHA_SETUP_H
 #define __ALPHA_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 /*
  * We leave one page for the initial stack page, and one page for
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 9596b0a..b9e5351 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -141,6 +141,12 @@ config ARC_HAS_REENTRANT_IRQ_LV2
 
 endif
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-4096)"
 	range 2 4096
diff --git a/arch/arc/include/asm/setup.h b/arch/arc/include/asm/setup.h
index e10f8ce..9708f1a 100644
--- a/arch/arc/include/asm/setup.h
+++ b/arch/arc/include/asm/setup.h
@@ -12,7 +12,9 @@
 #include <linux/types.h>
 #include <uapi/asm/setup.h>
 
-#define COMMAND_LINE_SIZE 256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 /*
  * Data structure to map a ID to string
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb..d5fadfa 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1615,6 +1615,12 @@ config PAGE_OFFSET
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "1024"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/arm/include/uapi/asm/setup.h b/arch/arm/include/uapi/asm/setup.h
index 979ff40..9cded84 100644
--- a/arch/arm/include/uapi/asm/setup.h
+++ b/arch/arm/include/uapi/asm/setup.h
@@ -16,7 +16,9 @@
 
 #include <linux/types.h>
 
-#define COMMAND_LINE_SIZE 1024
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 /* The list ends with an ATAG_NONE node. */
 #define ATAG_NONE	0x00000000
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..528845f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -186,6 +186,12 @@ config SCHED_SMT
 	  MultiThreading at a cost of slightly increased overhead in some
 	  places. If unsure say N here.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "2048"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/arm64/include/uapi/asm/setup.h b/arch/arm64/include/uapi/asm/setup.h
index 9cf2e46..f5ade83 100644
--- a/arch/arm64/include/uapi/asm/setup.h
+++ b/arch/arm64/include/uapi/asm/setup.h
@@ -21,6 +21,8 @@
 
 #include <linux/types.h>
 
-#define COMMAND_LINE_SIZE	2048
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b6878eb..e1ebdd6 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -233,6 +233,12 @@ config NMI_DEBUGGING
 
 source "kernel/Kconfig.hz"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Default kernel command line"
 	default ""
diff --git a/arch/avr32/include/uapi/asm/setup.h b/arch/avr32/include/uapi/asm/setup.h
index a654df7..b78cc6d 100644
--- a/arch/avr32/include/uapi/asm/setup.h
+++ b/arch/avr32/include/uapi/asm/setup.h
@@ -11,6 +11,8 @@
 #ifndef _UAPI__ASM_AVR32_SETUP_H__
 #define _UAPI__ASM_AVR32_SETUP_H__
 
-#define COMMAND_LINE_SIZE 256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI__ASM_AVR32_SETUP_H__ */
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 77ea09b..9a91e99 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -57,6 +57,12 @@ source "kernel/Kconfig.freezer"
 config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "1024"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Kernel command line"
 	depends on CMDLINE_BOOL
diff --git a/arch/c6x/include/uapi/asm/setup.h b/arch/c6x/include/uapi/asm/setup.h
index ad9ac97..73e46d3 100644
--- a/arch/c6x/include/uapi/asm/setup.h
+++ b/arch/c6x/include/uapi/asm/setup.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI_ASM_C6X_SETUP_H
 #define _UAPI_ASM_C6X_SETUP_H
 
-#define COMMAND_LINE_SIZE   1024
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_ASM_C6X_SETUP_H */
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 52731e2..d4dd8bc 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -65,6 +65,12 @@ menu "General setup"
 
 source "fs/Kconfig.binfmt"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config ETRAX_CMDLINE
 	string "Kernel command line"
 	default "root=/dev/mtdblock3"
diff --git a/arch/cris/include/uapi/asm/setup.h b/arch/cris/include/uapi/asm/setup.h
index b907286..fbad81d 100644
--- a/arch/cris/include/uapi/asm/setup.h
+++ b/arch/cris/include/uapi/asm/setup.h
@@ -1,6 +1,8 @@
 #ifndef _CRIS_SETUP_H
 #define _CRIS_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 34aa193..6f5b071 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -54,6 +54,12 @@ config HZ
 	int
 	default 1000
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "512"
+        help
+        This is the per architecture maximum command line size.
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/frv/include/uapi/asm/setup.h b/arch/frv/include/uapi/asm/setup.h
index fbf3fc9..c4ed2bf 100644
--- a/arch/frv/include/uapi/asm/setup.h
+++ b/arch/frv/include/uapi/asm/setup.h
@@ -12,7 +12,8 @@
 #ifndef _UAPI_ASM_SETUP_H
 #define _UAPI_ASM_SETUP_H
 
-#define COMMAND_LINE_SIZE       512
-
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_ASM_SETUP_H */
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 12c3afe..92c1754 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -352,6 +352,12 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "2048"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-4096)"
 	range 2 4096
diff --git a/arch/ia64/include/uapi/asm/setup.h b/arch/ia64/include/uapi/asm/setup.h
index 8d56458..ecfeea7 100644
--- a/arch/ia64/include/uapi/asm/setup.h
+++ b/arch/ia64/include/uapi/asm/setup.h
@@ -1,7 +1,9 @@
 #ifndef __IA64_SETUP_H
 #define __IA64_SETUP_H
 
-#define COMMAND_LINE_SIZE	2048
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 extern struct ia64_boot_param {
 	__u64 command_line;		/* physical address of command line arguments */
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 9e44bbd..72c265c 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -300,6 +300,12 @@ config CHIP_M32700_TS1
 	depends on (CHIP_M32700 && SMP)
 	default n
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "512"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/m32r/include/uapi/asm/setup.h b/arch/m32r/include/uapi/asm/setup.h
index 96961a4..a45fbef 100644
--- a/arch/m32r/include/uapi/asm/setup.h
+++ b/arch/m32r/include/uapi/asm/setup.h
@@ -5,7 +5,8 @@
  * This is set up by the setup-routine at boot-time
  */
 
-#define COMMAND_LINE_SIZE       512
-
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_ASM_M32R_SETUP_H */
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 87b7c75..9f68b97 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -124,6 +124,12 @@ endmenu
 
 menu "Kernel Features"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 if COLDFIRE
 source "kernel/Kconfig.preempt"
 endif
diff --git a/arch/m68k/include/uapi/asm/setup.h b/arch/m68k/include/uapi/asm/setup.h
index 6a6dc63..a96470e 100644
--- a/arch/m68k/include/uapi/asm/setup.h
+++ b/arch/m68k/include/uapi/asm/setup.h
@@ -11,6 +11,8 @@
 #ifndef _UAPI_M68K_SETUP_H
 #define _UAPI_M68K_SETUP_H
 
-#define COMMAND_LINE_SIZE 256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_M68K_SETUP_H */
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 9ae0854..fa409d6 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -91,6 +91,12 @@ comment "Boot options"
 config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Default kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/microblaze/include/uapi/asm/setup.h b/arch/microblaze/include/uapi/asm/setup.h
index 76bc2ac..5992d0b 100644
--- a/arch/microblaze/include/uapi/asm/setup.h
+++ b/arch/microblaze/include/uapi/asm/setup.h
@@ -11,7 +11,9 @@
 #ifndef _UAPI_ASM_MICROBLAZE_SETUP_H
 #define _UAPI_ASM_MICROBLAZE_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 # ifndef __ASSEMBLY__
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5cd695f..1200836 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2247,6 +2247,12 @@ config HW_PERF_EVENTS
 
 source "mm/Kconfig"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "4096"
+        help
+        This is the per architecture maximum command line size.
+
 config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
diff --git a/arch/mips/include/uapi/asm/setup.h b/arch/mips/include/uapi/asm/setup.h
index 93f237b..323902a 100644
--- a/arch/mips/include/uapi/asm/setup.h
+++ b/arch/mips/include/uapi/asm/setup.h
@@ -1,7 +1,8 @@
 #ifndef _UAPI_MIPS_SETUP_H
 #define _UAPI_MIPS_SETUP_H
 
-#define COMMAND_LINE_SIZE	4096
-
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_MIPS_SETUP_H */
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a648de1..4a940bc 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -199,6 +199,12 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int
 	depends on SMP
diff --git a/arch/mn10300/include/uapi/asm/param.h b/arch/mn10300/include/uapi/asm/param.h
index 02a0ca6..b632f88 100644
--- a/arch/mn10300/include/uapi/asm/param.h
+++ b/arch/mn10300/include/uapi/asm/param.h
@@ -13,6 +13,8 @@
 
 #include <asm-generic/param.h>
 
-#define COMMAND_LINE_SIZE 256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _ASM_PARAM_H */
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 1faefed..633ab34 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -295,6 +295,12 @@ config HPUX
 	bool "Support for HP-UX binaries"
 	depends on !64BIT
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "1024"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/parisc/include/uapi/asm/setup.h b/arch/parisc/include/uapi/asm/setup.h
index 7da2e5b..c70453f 100644
--- a/arch/parisc/include/uapi/asm/setup.h
+++ b/arch/parisc/include/uapi/asm/setup.h
@@ -1,6 +1,8 @@
 #ifndef _PARISC_SETUP_H
 #define _PARISC_SETUP_H
 
-#define COMMAND_LINE_SIZE	1024
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _PARISC_SETUP_H */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e099899..3426bdc 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -612,6 +612,12 @@ config PPC_DENORMALISATION
 config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "512"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Initial kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
index b3218ce..8a91edb 100644
--- a/arch/powerpc/boot/ops.h
+++ b/arch/powerpc/boot/ops.h
@@ -15,7 +15,10 @@
 #include "types.h"
 #include "string.h"
 
-#define	COMMAND_LINE_SIZE	512
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
+
 #define	MAX_PATH_LEN		256
 #define	MAX_PROP_LEN		256 /* What should this be? */
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d68fe34..01cfcbb 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -348,6 +348,12 @@ config SMP
 
 	  Even if you don't know what to do here, say Y.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "4096"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-256)"
 	range 2 256
diff --git a/arch/s390/include/uapi/asm/setup.h b/arch/s390/include/uapi/asm/setup.h
index 5a637e3..23e51e1 100644
--- a/arch/s390/include/uapi/asm/setup.h
+++ b/arch/s390/include/uapi/asm/setup.h
@@ -6,7 +6,9 @@
 #ifndef _UAPI_ASM_S390_SETUP_H
 #define _UAPI_ASM_S390_SETUP_H
 
-#define COMMAND_LINE_SIZE	4096
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #define ARCH_COMMAND_LINE_SIZE	896
 
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4ac8cae..63de4bd 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -58,6 +58,12 @@ config 32BIT
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 source "mm/Kconfig"
 
 config MEMORY_START
diff --git a/arch/score/include/uapi/asm/setup.h b/arch/score/include/uapi/asm/setup.h
index ab9dbdb..aa59951 100644
--- a/arch/score/include/uapi/asm/setup.h
+++ b/arch/score/include/uapi/asm/setup.h
@@ -1,7 +1,10 @@
 #ifndef _UAPI_ASM_SCORE_SETUP_H
 #define _UAPI_ASM_SCORE_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
+
 #define MEMORY_START		0
 #define MEMORY_SIZE		0x2000000
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 29f2e98..148114d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -329,6 +329,13 @@ config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 	depends on SPARC64
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256" if SPARC32
+        default "2048" if SPARC64
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Initial kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/sparc/include/uapi/asm/setup.h b/arch/sparc/include/uapi/asm/setup.h
index 5337684..bcf105b 100644
--- a/arch/sparc/include/uapi/asm/setup.h
+++ b/arch/sparc/include/uapi/asm/setup.h
@@ -5,11 +5,8 @@
 #ifndef _UAPI_SPARC_SETUP_H
 #define _UAPI_SPARC_SETUP_H
 
-#if defined(__sparc__) && defined(__arch64__)
-# define COMMAND_LINE_SIZE 2048
-#else
-# define COMMAND_LINE_SIZE 256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
 #endif
 
-
 #endif /* _UAPI_SPARC_SETUP_H */
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 85258ca..6aa6d6a 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -336,6 +336,12 @@ config CMDLINE_BOOL
 	  Systems with fully functional boot loaders (e.g. mboot, or
 	  if booting over PCI) should leave this option set to 'N'.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "2048"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Built-in kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/tile/include/uapi/asm/setup.h b/arch/tile/include/uapi/asm/setup.h
index e6f7da2..7e1e7dd 100644
--- a/arch/tile/include/uapi/asm/setup.h
+++ b/arch/tile/include/uapi/asm/setup.h
@@ -15,7 +15,8 @@
 #ifndef _UAPI_ASM_TILE_SETUP_H
 #define _UAPI_ASM_TILE_SETUP_H
 
-#define COMMAND_LINE_SIZE	2048
-
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif /* _UAPI_ASM_TILE_SETUP_H */
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index a7520c9..c0af3f9 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -119,6 +119,12 @@ config SMP
 
 	  If you don't know what to do, say N.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "4096"
+        help
+        This is the per architecture maximum command line size.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff --git a/arch/um/include/asm/setup.h b/arch/um/include/asm/setup.h
index 99f0863..ec3c951 100644
--- a/arch/um/include/asm/setup.h
+++ b/arch/um/include/asm/setup.h
@@ -5,6 +5,8 @@
  * command line, so this choice is ok.
  */
 
-#define COMMAND_LINE_SIZE 4096
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #endif		/* SETUP_H_INCLUDED */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..67a70ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1826,6 +1826,12 @@ config CMDLINE_BOOL
 	  Systems with fully functional boot loaders (i.e. non-embedded)
 	  should leave this option set to 'N'.
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "2048"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Built-in kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9264f04..0ab46ee 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -3,7 +3,9 @@
 
 #include <uapi/asm/setup.h>
 
-#define COMMAND_LINE_SIZE 2048
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 #include <linux/linkage.h>
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 02d6d29..00874f8 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -266,6 +266,12 @@ config GENERIC_CALIBRATE_DELAY
 config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 
+config COMMAND_LINE_SIZE
+        int "Maximum size of the command line."
+        default "256"
+        help
+        This is the per architecture maximum command line size.
+
 config CMDLINE
 	string "Initial kernel command string"
 	depends on CMDLINE_BOOL
diff --git a/arch/xtensa/include/uapi/asm/setup.h b/arch/xtensa/include/uapi/asm/setup.h
index 9fa8ad9..c320d8e 100644
--- a/arch/xtensa/include/uapi/asm/setup.h
+++ b/arch/xtensa/include/uapi/asm/setup.h
@@ -11,7 +11,9 @@
 #ifndef _XTENSA_SETUP_H
 #define _XTENSA_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#ifdef CONFIG_COMMAND_LINE_SIZE
+#define COMMAND_LINE_SIZE CONFIG_COMMAND_LINE_SIZE
+#endif
 
 extern void set_except_vector(int n, void *addr);
 
diff --git a/include/uapi/asm-generic/setup.h b/include/uapi/asm-generic/setup.h
index 6fc26a5..0ec13fc 100644
--- a/include/uapi/asm-generic/setup.h
+++ b/include/uapi/asm-generic/setup.h
@@ -1,6 +1,6 @@
 #ifndef __ASM_GENERIC_SETUP_H
 #define __ASM_GENERIC_SETUP_H
 
-#define COMMAND_LINE_SIZE	512
+#define COMMAND_LINE_SIZE       512
 
 #endif	/* __ASM_GENERIC_SETUP_H */
-- 
1.9.1

