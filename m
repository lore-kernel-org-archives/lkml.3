Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab3JPMcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:32:06 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:41676 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934322Ab3JPMb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 08/16] m68k/UAPI: Disintegrate arch/m68k/include/asm/bootinfo.h
Date: Wed, 16 Oct 2013 14:31:25 +0200
Message-Id: <1381926693-6392-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the bootinfo definitions that are used by bootstrap loaders, and
split them up in generic and platform-specific parts.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/amiga/config.c                     |    1 +
 arch/m68k/apollo/config.c                    |    1 +
 arch/m68k/atari/config.c                     |    1 +
 arch/m68k/bvme6000/config.c                  |    1 +
 arch/m68k/hp300/config.c                     |    1 +
 arch/m68k/include/asm/atarihw.h              |    2 +-
 arch/m68k/include/asm/bootinfo.h             |  183 +-------------------------
 arch/m68k/include/uapi/asm/Kbuild            |    8 ++
 arch/m68k/include/uapi/asm/bootinfo-amiga.h  |   31 +++++
 arch/m68k/include/uapi/asm/bootinfo-apollo.h |   16 +++
 arch/m68k/include/uapi/asm/bootinfo-atari.h  |   44 +++++++
 arch/m68k/include/uapi/asm/bootinfo-hp300.h  |   25 ++++
 arch/m68k/include/uapi/asm/bootinfo-mac.h    |   34 +++++
 arch/m68k/include/uapi/asm/bootinfo-q40.h    |   16 +++
 arch/m68k/include/uapi/asm/bootinfo-vme.h    |   46 +++++++
 arch/m68k/include/uapi/asm/bootinfo.h        |   95 +++++++++++++
 arch/m68k/kernel/head.S                      |    6 +
 arch/m68k/mac/config.c                       |    1 +
 arch/m68k/mvme147/config.c                   |    1 +
 arch/m68k/mvme16x/config.c                   |    1 +
 20 files changed, 331 insertions(+), 183 deletions(-)
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-amiga.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-apollo.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-atari.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-hp300.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-mac.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-q40.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-vme.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo.h

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 65b5e937ebba..0c92c1baf9bf 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -28,6 +28,7 @@
 #include <linux/keyboard.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-amiga.h>
 #include <asm/byteorder.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 2bdde9685a29..c90c19e904bc 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -10,6 +10,7 @@
 
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-apollo.h>
 #include <asm/pgtable.h>
 #include <asm/apollohw.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index fb2d0bd9b3ad..9159195505d5 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-atari.h>
 #include <asm/setup.h>
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 1b9e31e0130f..4d1b403822fa 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -28,6 +28,7 @@
 #include <linux/bcd.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-vme.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/hp300/config.c b/arch/m68k/hp300/config.c
index b7609f791522..892d0794fc0b 100644
--- a/arch/m68k/hp300/config.c
+++ b/arch/m68k/hp300/config.c
@@ -14,6 +14,7 @@
 #include <linux/console.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-hp300.h>
 #include <asm/machdep.h>
 #include <asm/blinken.h>
 #include <asm/io.h>                               /* readb() and writeb() */
diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index d887050e6da6..972c8f33f055 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -21,7 +21,7 @@
 #define _LINUX_ATARIHW_H_
 
 #include <linux/types.h>
-#include <asm/bootinfo.h>
+#include <asm/bootinfo-atari.h>
 #include <asm/raw_io.h>
 
 extern u_long atari_mch_cookie;
diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index 007c95759e6b..8e213267f8e7 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -6,46 +6,16 @@
 ** This file is subject to the terms and conditions of the GNU General Public
 ** License.  See the file COPYING in the main directory of this archive
 ** for more details.
-**
-** Created 09/29/92 by Greg Harp
-**
-** 5/2/94 Roman Hodek:
-**   Added bi_atari part of the machine dependent union bi_un; for now it
-**   contains just a model field to distinguish between TT and Falcon.
-** 26/7/96 Roman Zippel:
-**   Renamed to setup.h; added some useful macros to allow gcc some
-**   optimizations if possible.
-** 5/10/96 Geert Uytterhoeven:
-**   Redesign of the boot information structure; renamed to bootinfo.h again
-** 27/11/96 Geert Uytterhoeven:
-**   Backwards compatibility with bootinfo interface version 1.0
 */
 
 #ifndef _M68K_BOOTINFO_H
 #define _M68K_BOOTINFO_H
 
+#include <uapi/asm/bootinfo.h>
 
-    /*
-     *  Bootinfo definitions
-     *
-     *  This is an easily parsable and extendable structure containing all
-     *  information to be passed from the bootstrap to the kernel.
-     *
-     *  This way I hope to keep all future changes back/forewards compatible.
-     *  Thus, keep your fingers crossed...
-     *
-     *  This structure is copied right after the kernel by the bootstrap
-     *  routine.
-     */
 
 #ifndef __ASSEMBLY__
 
-struct bi_record {
-    unsigned short tag;			/* tag ID */
-    unsigned short size;		/* size of record (in bytes) */
-    unsigned long data[0];		/* data */
-};
-
 #ifdef CONFIG_BOOTINFO_PROC
 extern void save_bootinfo(const struct bi_record *bi);
 #else
@@ -55,155 +25,4 @@ static inline void save_bootinfo(const struct bi_record *bi) {}
 #endif /* __ASSEMBLY__ */
 
 
-    /*
-     *  Tag Definitions
-     *
-     *  Machine independent tags start counting from 0x0000
-     *  Machine dependent tags start counting from 0x8000
-     */
-
-#define BI_LAST			0x0000	/* last record (sentinel) */
-#define BI_MACHTYPE		0x0001	/* machine type (u_long) */
-#define BI_CPUTYPE		0x0002	/* cpu type (u_long) */
-#define BI_FPUTYPE		0x0003	/* fpu type (u_long) */
-#define BI_MMUTYPE		0x0004	/* mmu type (u_long) */
-#define BI_MEMCHUNK		0x0005	/* memory chunk address and size */
-					/* (struct mem_info) */
-#define BI_RAMDISK		0x0006	/* ramdisk address and size */
-					/* (struct mem_info) */
-#define BI_COMMAND_LINE		0x0007	/* kernel command line parameters */
-					/* (string) */
-
-    /*
-     *  Amiga-specific tags
-     */
-
-#define BI_AMIGA_MODEL		0x8000	/* model (u_long) */
-#define BI_AMIGA_AUTOCON	0x8001	/* AutoConfig device */
-					/* (struct ConfigDev) */
-#define BI_AMIGA_CHIP_SIZE	0x8002	/* size of Chip RAM (u_long) */
-#define BI_AMIGA_VBLANK		0x8003	/* VBLANK frequency (u_char) */
-#define BI_AMIGA_PSFREQ		0x8004	/* power supply frequency (u_char) */
-#define BI_AMIGA_ECLOCK		0x8005	/* EClock frequency (u_long) */
-#define BI_AMIGA_CHIPSET	0x8006	/* native chipset present (u_long) */
-#define BI_AMIGA_SERPER		0x8007	/* serial port period (u_short) */
-
-    /*
-     *  Atari-specific tags
-     */
-
-#define BI_ATARI_MCH_COOKIE	0x8000	/* _MCH cookie from TOS (u_long) */
-#define BI_ATARI_MCH_TYPE	0x8001	/* special machine type (u_long) */
-					/* (values are ATARI_MACH_* defines */
-
-/* mch_cookie values (upper word) */
-#define ATARI_MCH_ST		0
-#define ATARI_MCH_STE		1
-#define ATARI_MCH_TT		2
-#define ATARI_MCH_FALCON	3
-
-/* mch_type values */
-#define ATARI_MACH_NORMAL	0	/* no special machine type */
-#define ATARI_MACH_MEDUSA	1	/* Medusa 040 */
-#define ATARI_MACH_HADES	2	/* Hades 040 or 060 */
-#define ATARI_MACH_AB40		3	/* Afterburner040 on Falcon */
-
-    /*
-     *  VME-specific tags
-     */
-
-#define BI_VME_TYPE		0x8000	/* VME sub-architecture (u_long) */
-#define BI_VME_BRDINFO		0x8001	/* VME board information (struct) */
-
-/* BI_VME_TYPE codes */
-#define	VME_TYPE_TP34V		0x0034	/* Tadpole TP34V */
-#define VME_TYPE_MVME147	0x0147	/* Motorola MVME147 */
-#define VME_TYPE_MVME162	0x0162	/* Motorola MVME162 */
-#define VME_TYPE_MVME166	0x0166	/* Motorola MVME166 */
-#define VME_TYPE_MVME167	0x0167	/* Motorola MVME167 */
-#define VME_TYPE_MVME172	0x0172	/* Motorola MVME172 */
-#define VME_TYPE_MVME177	0x0177	/* Motorola MVME177 */
-#define VME_TYPE_BVME4000	0x4000	/* BVM Ltd. BVME4000 */
-#define VME_TYPE_BVME6000	0x6000	/* BVM Ltd. BVME6000 */
-
-/* BI_VME_BRDINFO is a 32 byte struct as returned by the Bug code on
- * Motorola VME boards.  Contains board number, Bug version, board
- * configuration options, etc.  See include/asm/mvme16xhw.h for details.
- */
-
-
-    /*
-     *  Macintosh-specific tags (all u_long)
-     */
-
-#define BI_MAC_MODEL		0x8000	/* Mac Gestalt ID (model type) */
-#define BI_MAC_VADDR		0x8001	/* Mac video base address */
-#define BI_MAC_VDEPTH		0x8002	/* Mac video depth */
-#define BI_MAC_VROW		0x8003	/* Mac video rowbytes */
-#define BI_MAC_VDIM		0x8004	/* Mac video dimensions */
-#define BI_MAC_VLOGICAL		0x8005	/* Mac video logical base */
-#define BI_MAC_SCCBASE		0x8006	/* Mac SCC base address */
-#define BI_MAC_BTIME		0x8007	/* Mac boot time */
-#define BI_MAC_GMTBIAS		0x8008	/* Mac GMT timezone offset */
-#define BI_MAC_MEMSIZE		0x8009	/* Mac RAM size (sanity check) */
-#define BI_MAC_CPUID		0x800a	/* Mac CPU type (sanity check) */
-#define BI_MAC_ROMBASE		0x800b	/* Mac system ROM base address */
-
-
-    /*
-     *  Apollo-specific tags
-     */
-
-#define BI_APOLLO_MODEL         0x8000  /* model (u_long) */
-
-    /*
-     *  HP300-specific tags
-     */
-
-#define BI_HP300_MODEL		0x8000	/* model (u_long) */
-#define BI_HP300_UART_SCODE	0x8001	/* UART select code (u_long) */
-#define BI_HP300_UART_ADDR	0x8002	/* phys. addr of UART (u_long) */
-
-    /*
-     * Stuff for bootinfo interface versioning
-     *
-     * At the start of kernel code, a 'struct bootversion' is located.
-     * bootstrap checks for a matching version of the interface before booting
-     * a kernel, to avoid user confusion if kernel and bootstrap don't work
-     * together :-)
-     *
-     * If incompatible changes are made to the bootinfo interface, the major
-     * number below should be stepped (and the minor reset to 0) for the
-     * appropriate machine. If a change is backward-compatible, the minor
-     * should be stepped. "Backwards-compatible" means that booting will work,
-     * but certain features may not.
-     */
-
-#define BOOTINFOV_MAGIC			0x4249561A	/* 'BIV^Z' */
-#define MK_BI_VERSION(major,minor)	(((major)<<16)+(minor))
-#define BI_VERSION_MAJOR(v)		(((v) >> 16) & 0xffff)
-#define BI_VERSION_MINOR(v)		((v) & 0xffff)
-
-#ifndef __ASSEMBLY__
-
-struct bootversion {
-    unsigned short branch;
-    unsigned long magic;
-    struct {
-	unsigned long machtype;
-	unsigned long version;
-    } machversions[0];
-};
-
-#endif /* __ASSEMBLY__ */
-
-#define AMIGA_BOOTI_VERSION    MK_BI_VERSION( 2, 0 )
-#define ATARI_BOOTI_VERSION    MK_BI_VERSION( 2, 1 )
-#define MAC_BOOTI_VERSION      MK_BI_VERSION( 2, 0 )
-#define MVME147_BOOTI_VERSION  MK_BI_VERSION( 2, 0 )
-#define MVME16x_BOOTI_VERSION  MK_BI_VERSION( 2, 0 )
-#define BVME6000_BOOTI_VERSION MK_BI_VERSION( 2, 0 )
-#define Q40_BOOTI_VERSION      MK_BI_VERSION( 2, 0 )
-#define HP300_BOOTI_VERSION    MK_BI_VERSION( 2, 0 )
-
 #endif /* _M68K_BOOTINFO_H */
diff --git a/arch/m68k/include/uapi/asm/Kbuild b/arch/m68k/include/uapi/asm/Kbuild
index 1fef45ada097..6a2d257bdfb2 100644
--- a/arch/m68k/include/uapi/asm/Kbuild
+++ b/arch/m68k/include/uapi/asm/Kbuild
@@ -11,6 +11,14 @@ generic-y += termbits.h
 generic-y += termios.h
 
 header-y += a.out.h
+header-y += bootinfo.h
+header-y += bootinfo-amiga.h
+header-y += bootinfo-apollo.h
+header-y += bootinfo-atari.h
+header-y += bootinfo-hp300.h
+header-y += bootinfo-mac.h
+header-y += bootinfo-q40.h
+header-y += bootinfo-vme.h
 header-y += byteorder.h
 header-y += cachectl.h
 header-y += fcntl.h
diff --git a/arch/m68k/include/uapi/asm/bootinfo-amiga.h b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
new file mode 100644
index 000000000000..2c32d671f232
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
@@ -0,0 +1,31 @@
+/*
+** asm/bootinfo-amiga.h -- Amiga-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_AMIGA_H
+#define _UAPI_ASM_M68K_BOOTINFO_AMIGA_H
+
+
+    /*
+     *  Amiga-specific tags
+     */
+
+#define BI_AMIGA_MODEL		0x8000	/* model (u_long) */
+#define BI_AMIGA_AUTOCON	0x8001	/* AutoConfig device */
+					/* (AmigaOS struct ConfigDev) */
+#define BI_AMIGA_CHIP_SIZE	0x8002	/* size of Chip RAM (u_long) */
+#define BI_AMIGA_VBLANK		0x8003	/* VBLANK frequency (u_char) */
+#define BI_AMIGA_PSFREQ		0x8004	/* power supply frequency (u_char) */
+#define BI_AMIGA_ECLOCK		0x8005	/* EClock frequency (u_long) */
+#define BI_AMIGA_CHIPSET	0x8006	/* native chipset present (u_long) */
+#define BI_AMIGA_SERPER		0x8007	/* serial port period (u_short) */
+
+
+    /*
+     *  Latest Amiga bootinfo version
+     */
+
+#define AMIGA_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_AMIGA_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-apollo.h b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
new file mode 100644
index 000000000000..3a2051e822b0
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
@@ -0,0 +1,16 @@
+/*
+** asm/bootinfo-apollo.h -- Apollo-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_APOLLO_H
+#define _UAPI_ASM_M68K_BOOTINFO_APOLLO_H
+
+
+    /*
+     *  Apollo-specific tags
+     */
+
+#define BI_APOLLO_MODEL		0x8000	/* model (u_long) */
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_APOLLO_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-atari.h b/arch/m68k/include/uapi/asm/bootinfo-atari.h
new file mode 100644
index 000000000000..cca0a83fc0e5
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-atari.h
@@ -0,0 +1,44 @@
+/*
+** asm/bootinfo-atari.h -- Atari-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_ATARI_H
+#define _UAPI_ASM_M68K_BOOTINFO_ATARI_H
+
+
+    /*
+     *  Atari-specific tags
+     */
+
+#define BI_ATARI_MCH_COOKIE	0x8000	/* _MCH cookie from TOS (u_long) */
+#define BI_ATARI_MCH_TYPE	0x8001	/* special machine type (u_long) */
+
+
+    /*
+     *  mch_cookie values (upper word of BI_ATARI_MCH_COOKIE)
+     */
+
+#define ATARI_MCH_ST		0
+#define ATARI_MCH_STE		1
+#define ATARI_MCH_TT		2
+#define ATARI_MCH_FALCON	3
+
+
+    /*
+     *  Atari machine types (BI_ATARI_MCH_TYPE)
+     */
+
+#define ATARI_MACH_NORMAL	0	/* no special machine type */
+#define ATARI_MACH_MEDUSA	1	/* Medusa 040 */
+#define ATARI_MACH_HADES	2	/* Hades 040 or 060 */
+#define ATARI_MACH_AB40		3	/* Afterburner040 on Falcon */
+
+
+    /*
+     *  Latest Atari bootinfo version
+     */
+
+#define ATARI_BOOTI_VERSION	MK_BI_VERSION(2, 1)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_ATARI_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-hp300.h b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
new file mode 100644
index 000000000000..e7ed19cdafe5
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
@@ -0,0 +1,25 @@
+/*
+** asm/bootinfo-hp300.h -- HP9000/300-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_HP300_H
+#define _UAPI_ASM_M68K_BOOTINFO_HP300_H
+
+
+    /*
+     *  HP9000/300-specific tags
+     */
+
+#define BI_HP300_MODEL		0x8000	/* model (u_long) */
+#define BI_HP300_UART_SCODE	0x8001	/* UART select code (u_long) */
+#define BI_HP300_UART_ADDR	0x8002	/* phys. addr of UART (u_long) */
+
+
+    /*
+     *  Latest HP9000/300 bootinfo version
+     */
+
+#define HP300_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_HP300_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-mac.h b/arch/m68k/include/uapi/asm/bootinfo-mac.h
new file mode 100644
index 000000000000..29a4109ab089
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-mac.h
@@ -0,0 +1,34 @@
+/*
+** asm/bootinfo-mac.h -- Macintosh-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_MAC_H
+#define _UAPI_ASM_M68K_BOOTINFO_MAC_H
+
+
+    /*
+     *  Macintosh-specific tags (all u_long)
+     */
+
+#define BI_MAC_MODEL		0x8000	/* Mac Gestalt ID (model type) */
+#define BI_MAC_VADDR		0x8001	/* Mac video base address */
+#define BI_MAC_VDEPTH		0x8002	/* Mac video depth */
+#define BI_MAC_VROW		0x8003	/* Mac video rowbytes */
+#define BI_MAC_VDIM		0x8004	/* Mac video dimensions */
+#define BI_MAC_VLOGICAL		0x8005	/* Mac video logical base */
+#define BI_MAC_SCCBASE		0x8006	/* Mac SCC base address */
+#define BI_MAC_BTIME		0x8007	/* Mac boot time */
+#define BI_MAC_GMTBIAS		0x8008	/* Mac GMT timezone offset */
+#define BI_MAC_MEMSIZE		0x8009	/* Mac RAM size (sanity check) */
+#define BI_MAC_CPUID		0x800a	/* Mac CPU type (sanity check) */
+#define BI_MAC_ROMBASE		0x800b	/* Mac system ROM base address */
+
+
+    /*
+     *  Latest Macintosh bootinfo version
+     */
+
+#define MAC_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_MAC_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-q40.h b/arch/m68k/include/uapi/asm/bootinfo-q40.h
new file mode 100644
index 000000000000..c79fea7e555b
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-q40.h
@@ -0,0 +1,16 @@
+/*
+** asm/bootinfo-q40.h -- Q40-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_Q40_H
+#define _UAPI_ASM_M68K_BOOTINFO_Q40_H
+
+
+    /*
+     *  Latest Q40 bootinfo version
+     */
+
+#define Q40_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_Q40_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-vme.h b/arch/m68k/include/uapi/asm/bootinfo-vme.h
new file mode 100644
index 000000000000..4643a55ed768
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo-vme.h
@@ -0,0 +1,46 @@
+/*
+** asm/bootinfo-vme.h -- VME-specific boot information definitions
+*/
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_VME_H
+#define _UAPI_ASM_M68K_BOOTINFO_VME_H
+
+
+    /*
+     *  VME-specific tags
+     */
+
+#define BI_VME_TYPE		0x8000	/* VME sub-architecture (u_long) */
+#define BI_VME_BRDINFO		0x8001	/* VME board information (struct) */
+
+
+    /*
+     *  VME models (BI_VME_TYPE)
+     */
+
+#define VME_TYPE_TP34V		0x0034	/* Tadpole TP34V */
+#define VME_TYPE_MVME147	0x0147	/* Motorola MVME147 */
+#define VME_TYPE_MVME162	0x0162	/* Motorola MVME162 */
+#define VME_TYPE_MVME166	0x0166	/* Motorola MVME166 */
+#define VME_TYPE_MVME167	0x0167	/* Motorola MVME167 */
+#define VME_TYPE_MVME172	0x0172	/* Motorola MVME172 */
+#define VME_TYPE_MVME177	0x0177	/* Motorola MVME177 */
+#define VME_TYPE_BVME4000	0x4000	/* BVM Ltd. BVME4000 */
+#define VME_TYPE_BVME6000	0x6000	/* BVM Ltd. BVME6000 */
+
+/* BI_VME_BRDINFO is a 32 byte struct as returned by the Bug code on
+ * Motorola VME boards.  Contains board number, Bug version, board
+ * configuration options, etc.  See include/asm/mvme16xhw.h for details.
+ */
+
+
+    /*
+     *  Latest VME bootinfo versions
+     */
+
+#define MVME147_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+#define MVME16x_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+#define BVME6000_BOOTI_VERSION	MK_BI_VERSION(2, 0)
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_VME_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo.h b/arch/m68k/include/uapi/asm/bootinfo.h
new file mode 100644
index 000000000000..74a6fae2a5bf
--- /dev/null
+++ b/arch/m68k/include/uapi/asm/bootinfo.h
@@ -0,0 +1,95 @@
+/*
+ * asm/bootinfo.h -- Definition of the Linux/m68k boot information structure
+ *
+ * Copyright 1992 by Greg Harp
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _UAPI_ASM_M68K_BOOTINFO_H
+#define _UAPI_ASM_M68K_BOOTINFO_H
+
+#include <linux/types.h>
+
+
+#ifndef __ASSEMBLY__
+
+    /*
+     *  Bootinfo definitions
+     *
+     *  This is an easily parsable and extendable structure containing all
+     *  information to be passed from the bootstrap to the kernel.
+     *
+     *  This way I hope to keep all future changes back/forewards compatible.
+     *  Thus, keep your fingers crossed...
+     *
+     *  This structure is copied right after the kernel by the bootstrap
+     *  routine.
+     */
+
+struct bi_record {
+	unsigned short tag;		/* tag ID */
+	unsigned short size;		/* size of record (in bytes) */
+	unsigned long data[0];		/* data */
+};
+
+#endif /* __ASSEMBLY__ */
+
+
+    /*
+     *  Tag Definitions
+     *
+     *  Machine independent tags start counting from 0x0000
+     *  Machine dependent tags start counting from 0x8000
+     */
+
+#define BI_LAST			0x0000	/* last record (sentinel) */
+#define BI_MACHTYPE		0x0001	/* machine type (u_long) */
+#define BI_CPUTYPE		0x0002	/* cpu type (u_long) */
+#define BI_FPUTYPE		0x0003	/* fpu type (u_long) */
+#define BI_MMUTYPE		0x0004	/* mmu type (u_long) */
+#define BI_MEMCHUNK		0x0005	/* memory chunk address and size */
+					/* (struct mem_info) */
+#define BI_RAMDISK		0x0006	/* ramdisk address and size */
+					/* (struct mem_info) */
+#define BI_COMMAND_LINE		0x0007	/* kernel command line parameters */
+					/* (string) */
+
+
+    /*
+     * Stuff for bootinfo interface versioning
+     *
+     * At the start of kernel code, a 'struct bootversion' is located.
+     * bootstrap checks for a matching version of the interface before booting
+     * a kernel, to avoid user confusion if kernel and bootstrap don't work
+     * together :-)
+     *
+     * If incompatible changes are made to the bootinfo interface, the major
+     * number below should be stepped (and the minor reset to 0) for the
+     * appropriate machine. If a change is backward-compatible, the minor
+     * should be stepped. "Backwards-compatible" means that booting will work,
+     * but certain features may not.
+     */
+
+#define BOOTINFOV_MAGIC			0x4249561A	/* 'BIV^Z' */
+#define MK_BI_VERSION(major, minor)	(((major) << 16) + (minor))
+#define BI_VERSION_MAJOR(v)		(((v) >> 16) & 0xffff)
+#define BI_VERSION_MINOR(v)		((v) & 0xffff)
+
+#ifndef __ASSEMBLY__
+
+struct bootversion {
+	unsigned short branch;
+	unsigned long magic;
+	struct {
+		unsigned long machtype;
+		unsigned long version;
+	} machversions[0];
+} __packed;
+
+#endif /* __ASSEMBLY__ */
+
+
+#endif /* _UAPI_ASM_M68K_BOOTINFO_H */
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index 28f817481f3b..7d7913f5dce3 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -257,6 +257,12 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-amiga.h>
+#include <asm/bootinfo-atari.h>
+#include <asm/bootinfo-hp300.h>
+#include <asm/bootinfo-mac.h>
+#include <asm/bootinfo-q40.h>
+#include <asm/bootinfo-vme.h>
 #include <asm/setup.h>
 #include <asm/entry.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 677244e0371c..e48069da04ed 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -28,6 +28,7 @@
 
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-mac.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 5c99154c67c8..3a1d47564e52 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-vme.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 60d8a1bc837d..e05994fd048c 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 
 #include <asm/bootinfo.h>
+#include <asm/bootinfo-vme.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
-- 
1.7.9.5

