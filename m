Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab3CGEs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:48:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50775 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3CGEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:48:26 -0500
Date: Thu, 7 Mar 2013 15:48:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH] Select VIRT_TO_BUS directly where needed
Message-Id: <20130307154816.4e3daace932faa4f8390e53e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Mar_2013_15_48_16_+1100_HK+JRFo_=aLEC.U3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Mar_2013_15_48_16_+1100_HK+JRFo_=aLEC.U3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In commit 887cbce0adea ("arch Kconfig: centralise
CONFIG_ARCH_NO_VIRT_TO_BUS") I introduced the config sybmol
HAVE_VIRT_TO_BUS and selected that where needed.  I am not sure what I was
thinking.  Instead, just directly select VIRT_TO_BUS where it is needed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/Kconfig            | 7 -------
 arch/alpha/Kconfig      | 2 +-
 arch/arm/Kconfig        | 2 +-
 arch/avr32/Kconfig      | 2 +-
 arch/blackfin/Kconfig   | 2 +-
 arch/cris/Kconfig       | 2 +-
 arch/frv/Kconfig        | 2 +-
 arch/h8300/Kconfig      | 2 +-
 arch/ia64/Kconfig       | 2 +-
 arch/m32r/Kconfig       | 2 +-
 arch/m68k/Kconfig       | 2 +-
 arch/microblaze/Kconfig | 2 +-
 arch/mips/Kconfig       | 2 +-
 arch/mn10300/Kconfig    | 2 +-
 arch/openrisc/Kconfig   | 2 +-
 arch/parisc/Kconfig     | 2 +-
 arch/powerpc/Kconfig    | 2 +-
 arch/s390/Kconfig       | 2 +-
 arch/score/Kconfig      | 2 +-
 arch/tile/Kconfig       | 2 +-
 arch/unicore32/Kconfig  | 2 +-
 arch/x86/Kconfig        | 2 +-
 arch/xtensa/Kconfig     | 2 +-
 mm/Kconfig              | 8 ++++++--
 24 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 5a1779c..1455579 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -319,13 +319,6 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
=20
-config HAVE_VIRT_TO_BUS
-	bool
-	help
-	  An architecture should select this if it implements the
-	  deprecated interface virt_to_bus().  All new architectures
-	  should probably not select this.
-
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5833aa4..8a33ba0 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -9,7 +9,7 @@ config ALPHA
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..fc6fe23 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,7 +49,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select KTIME_SCALAR
 	select PERF_USE_VMALLOC
 	select RTC_LIB
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 9b89257..c1a868d 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -7,7 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 600494c..c3f2e0b 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -33,7 +33,7 @@ config BLACKFIN
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index bb0ac66..06dd026 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -43,7 +43,7 @@ config CRIS
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 12369b1..2ce731f 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -6,7 +6,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ae8551e..79250de 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -5,7 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 33f3fdc..9a02f71 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -26,7 +26,7 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 9262381..bcd17b2 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,7 +10,7 @@ config M32R
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 0e708c7..6de8133 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,7 +8,7 @@ config M68K
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 7843d11..1323fa2 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -19,7 +19,7 @@ config MICROBLAZE
 	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ae9c716..cd2e21f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -38,7 +38,7 @@ config MIPS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index b06c736..428da17 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -8,7 +8,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select GENERIC_ATOMIC64
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 014a648..9862d20 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -12,7 +12,7 @@ config OPENRISC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index a9ff712..0339181 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -21,7 +21,7 @@ config PARISC
 	select GENERIC_STRNCPY_FROM_USER
 	select SYSCTL_ARCH_UNALIGN_ALLOW
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 	select TTY # Needed for pdc_cons.c
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b89d7eb..8082151 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -98,7 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select HAVE_VIRT_TO_BUS if !PPC64
+	select VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4b50537..eb8fb62 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -134,7 +134,7 @@ config S390
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select INIT_ALL_POSSIBLE
 	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index e569aa1..c8def8b 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -12,7 +12,7 @@ config SCORE
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
        select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
=20
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index ff496ab..25877ae 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -17,7 +17,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index dc50b15..2943e3a 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -9,7 +9,7 @@ config UNICORE32
 	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..70c0f3d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,7 +112,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 35876ff..b09de49 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -9,7 +9,7 @@ config XTENSA
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
diff --git a/mm/Kconfig b/mm/Kconfig
index ae55c1e..3bea74f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -286,8 +286,12 @@ config NR_QUICK
 	default "1"
=20
 config VIRT_TO_BUS
-	def_bool y
-	depends on HAVE_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it implements the
+	  deprecated interface virt_to_bus().  All new architectures
+	  should probably not select this.
+
=20
 config MMU_NOTIFIER
 	bool
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Mar_2013_15_48_16_+1100_HK+JRFo_=aLEC.U3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJROBwQAAoJEECxmPOUX5FE5u8QAKLumeLAyTZDyS1XqPrZeZ/7
rfB6nNbSPXJsEjnHvkZKrePRwTWAw540y5At8x/tbzWmKty79BX4E89soccex+sD
o766/jTghrLu2CnrHar6f51+A2TVHcvOeyxtJbYSvw79/b2lEDFgGDXl6UX9kLcz
q4It9EJXJ/HHViAS45gIru5ZfgEoWmp/bNE7OyLawzvCASY8DuzyS+rK33f57lXh
UNHMLO01trtdazGYdNvD16UvTB0LSMgSR0rxO0Zp60ivbV5xWk2CFFWGZ20PwTZu
jk2csh/kGQVxbAi/fjMUILVBfrIwnc0PbKyUQRRJ39VCdi+5CQXFP1WAQYjkafwE
/i4VvwTAnfUkPxQ9aktGlVIdCJKSpQcwnWi8/yOG/nFIvpq4xd+rUwj/Jo83pLkg
4slD2gERmDjpBsXpOUlA8SdPeibJpr9wmpM0pDYoiJg5lLPA+r7RXfGuFrfuMa3w
NGLe8KkJVHULjrafY2M3FPpKZE+JBHaE8G08A0WjhIkROSTu6gYG3Nb8ouik4KZc
E3DzLL4WQD6+hY1bvFE7rq99QIcFUUy2Oenm8V3bbosaelcydHd3nMuzCbMjLOWw
CoGdIdgwAtT2U7/+th2YxUEfpv+t7LDGqZgw2XezERW+aKoiEI/4EcDTeURDhPLe
VcxVFHoVHOY5jiH9yGxF
=u9sN
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Mar_2013_15_48_16_+1100_HK+JRFo_=aLEC.U3--
