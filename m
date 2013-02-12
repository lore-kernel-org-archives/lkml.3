Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3BLLrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:47:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55692 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3BLLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:47:43 -0500
Date: Tue, 12 Feb 2013 22:47:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        <linux-sh@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Message-Id: <20130212224729.5e60d0303bda923bebcc1185@canb.auug.org.au>
In-Reply-To: <20130212154010.3f8b88da4756c7cf04e28a04@canb.auug.org.au>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
	<CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
	<20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
	<5118DCA8.1030905@imgtec.com>
	<20130212154010.3f8b88da4756c7cf04e28a04@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_22_47_29_+1100_6PfRrR7m/A42zHi5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_22_47_29_+1100_6PfRrR7m/A42zHi5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Change it to CONFIG_HAVE_VIRT_TO_BUS and set it in all architecures
that already provide virt_to_bus().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/Kconfig            | 7 +++++++
 arch/alpha/Kconfig      | 1 +
 arch/arm/Kconfig        | 1 +
 arch/avr32/Kconfig      | 1 +
 arch/blackfin/Kconfig   | 1 +
 arch/cris/Kconfig       | 1 +
 arch/frv/Kconfig        | 1 +
 arch/h8300/Kconfig      | 1 +
 arch/ia64/Kconfig       | 1 +
 arch/m32r/Kconfig       | 1 +
 arch/m68k/Kconfig       | 1 +
 arch/microblaze/Kconfig | 1 +
 arch/mips/Kconfig       | 1 +
 arch/mn10300/Kconfig    | 1 +
 arch/openrisc/Kconfig   | 1 +
 arch/parisc/Kconfig     | 1 +
 arch/powerpc/Kconfig    | 4 +---
 arch/s390/Kconfig       | 1 +
 arch/score/Kconfig      | 1 +
 arch/sh/Kconfig         | 3 ---
 arch/sparc/Kconfig      | 3 ---
 arch/tile/Kconfig       | 1 +
 arch/unicore32/Kconfig  | 1 +
 arch/x86/Kconfig        | 1 +
 arch/xtensa/Kconfig     | 1 +
 mm/Kconfig              | 2 +-
 26 files changed, 30 insertions(+), 10 deletions(-)

This is based on v3.8-rc7. I think I got them all (apart from arc and metag=
).

diff --git a/arch/Kconfig b/arch/Kconfig
index 7f8f281..7721b40 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -291,6 +291,13 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
=20
+config HAVE_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it implements the
+	  deprecated interface virt_to_bus().  All new architectures
+	  should probably not select this.
+
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9d5904c..63f49b1 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -10,6 +10,7 @@ config ALPHA
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..23f99e1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,6 +49,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select KTIME_SCALAR
 	select PERF_USE_VMALLOC
 	select RTC_LIB
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 2ae6591..9b89257 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -7,6 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..834a6e3 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -34,6 +34,7 @@ config BLACKFIN
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index c59a01d..abe1fd2 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -43,6 +43,7 @@ config CRIS
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 9d26264..8ca9099 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 2d2efb6..ce7c55e 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -5,6 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3279646..4c09006 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -26,6 +26,7 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index f807721..9262381 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6710084..a12199b 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ba3b7c8..7843d11 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -19,6 +19,7 @@ config MICROBLAZE
 	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2ac626a..7013aaa 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -39,6 +39,7 @@ config MIPS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
=20
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index e70001c..0d1582d 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -8,6 +8,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select GENERIC_ATOMIC64
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
=20
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 0ac66f6..b62ed01 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -12,6 +12,7 @@ config OPENRISC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b77feff..598cf09 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -21,6 +21,7 @@ config PARISC
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
=20
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 17903f1..f492ad9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,9 +87,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool PPC64
-
 config PPC
 	bool
 	default y
@@ -101,6 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index b5ea38c..5d23fa6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -98,6 +98,7 @@ config S390
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
 	select BUILDTIME_EXTABLE_SORT
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 3b1482e..e569aa1 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -12,6 +12,7 @@ config SCORE
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
        select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
=20
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..efa4c8c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -150,9 +150,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
=20
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 9f2edb5..aaa20de 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -143,9 +143,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
=20
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 875d008..61a6e59 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -17,6 +17,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
+	select HAVE_VIRT_TO_BUS
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 60651df..dc50b15 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -9,6 +9,7 @@ config UNICORE32
 	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_VIRT_TO_BUS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 225543b..3d3304d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -110,6 +110,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 5aab1ac..e0c082b 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -9,6 +9,7 @@ config XTENSA
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
diff --git a/mm/Kconfig b/mm/Kconfig
index 278e3ab..6d5996f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -266,7 +266,7 @@ config NR_QUICK
=20
 config VIRT_TO_BUS
 	def_bool y
-	depends on !ARCH_NO_VIRT_TO_BUS
+	depends on HAVE_VIRT_TO_BUS
=20
 config MMU_NOTIFIER
 	bool
--=20
1.8.1


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Feb_2013_22_47_29_+1100_6PfRrR7m/A42zHi5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGivRAAoJEECxmPOUX5FEPyoQAKNI3YG5G5gAk+jkfYHvQlIE
DcWyKiNsjT9uRygoGTQLx5dxXBxvgeFuFS1D8Y32VRkgtL1Cc4mj/wKP7MmcxeNm
u3Cq6KRKXTTTpHOjzPFjchrAULaO5JvVHvXj9YwZwEvslKVl0DWktKXpYvOreNo2
Fp7RZst52u5AmFRpPlXzqcxWa39rNqrOqkSM0wM/kooHzQ8Z4jEw6fZhsLiX9c0u
ATnofRRrTQL9PV5Fw1YQU9BnU5voA0RtZ3y6Q/SNIivqUETQILppFQpuixAaG28J
2AgAjg/D9/1VAD441O9oKtYy0onOJb1agPbVB6F9eOHLN92dLV7jKUy635I8srCp
/iMjFqmpeiSubAK6B2H+bsEce8XaXO/qsGWxSQtsVTBnopotiYwuUfAYcFXWGQJ8
/8ETe8UwGAJAeTMt9XVsYWB09cI1ZqUaOxgz7Do3RozvrpmjKclW4edGLb1WrYbf
exrO+WLoNHXdLBxX5GQx4N5Y+mkYmbmq6EQMIbIYGZmUOFverguBYzdrhhW8S6XL
l0FEkvkIQziqT4/m7G5l0+5fGXwem5EY/puZAjcRhvHO0Tjf66aW9x5jvOh8L3ZF
usogL2AyTmbE6teSxoH+dDIa+gBjxy/2d6bhhMzufeU7nzJ1r99NsdXcwRghusYw
oNTTNCW8BhP/yWl+cJ+Q
=yDtp
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_22_47_29_+1100_6PfRrR7m/A42zHi5--
