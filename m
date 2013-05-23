Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3EWH6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:58:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:10246 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3EWH6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:58:31 -0400
X-Spam-Score: -100.8
Message-ID: <519DCBEF.3090208@asianux.com>
Date: Thu, 23 May 2013 15:57:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, Mike Frysinger <vapier@gentoo.org>,
        ysato@users.sourceforge.jp, rkuo@codeaurora.org, jejb@parisc-linux.org,
        deller@gmx.de, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        jdike@addtoit.com, richard@nod.at,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, paulmck@linux.vnet.ibm.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, akinobu.mita@gmail.com,
        Catalin Marinas <Catalin.Marinas@arm.com>, walken@google.com,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-hexagon@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, linux-arch@vger.kernel.org
Subject: [PATCH] arch: configuration, deleting 'CONFIG_BUG' since always need
 it.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The crazy user can unset 'CONFIG_BUG' in menuconfig: "> General setup >
Configure standard kernel features (expert users) > BUG() Support".

But in fact, we always need it, and quite a few of architectures have
already implemented it (e.g. alpha, arc, arm, avr32, blackfin, cris,
frv, ia64, m68k, mips, mn10300, parisc, powerpc, s390, sh, sparc, x86).

And kernel also already has prepared a default effective implementation
for the architectures which is unwilling to implement it by themselves
(e.g. arm64, c6x, h8300, hexagon, m32r, metag, microblaze, openrisc,
score, tile, um, unicore32, xtensa).

So need get rid of 'CONFIG_BUG', and let it always enabled everywhere.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/Kconfig          |    1 -
 arch/avr32/Kconfig        |    1 -
 arch/blackfin/Kconfig     |    1 -
 arch/h8300/Kconfig        |    1 -
 arch/hexagon/Kconfig      |    1 -
 arch/parisc/Kconfig       |    2 --
 arch/powerpc/Kconfig      |    1 -
 arch/s390/Kconfig         |    2 +-
 arch/sh/Kconfig           |    2 +-
 arch/um/Kconfig.common    |    1 -
 arch/x86/Kconfig          |    1 -
 include/asm-generic/bug.h |   29 -----------------------------
 init/Kconfig              |   10 ----------
 lib/Kconfig.debug         |    2 +-
 14 files changed, 3 insertions(+), 52 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7fc5ea..ea4a146 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -265,7 +265,6 @@ config PHYS_OFFSET
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG
 
 source "init/Kconfig"
 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index bdc3558..7c9005a 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -55,7 +55,6 @@ config GENERIC_CALIBRATE_DELAY
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG
 
 source "init/Kconfig"
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index a117652..637dc42 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -47,7 +47,6 @@ config GENERIC_CSUM
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG
 
 config ZONE_DMA
 	def_bool y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 303e4f9..88848da 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -56,7 +56,6 @@ config GENERIC_CALIBRATE_DELAY
 
 config GENERIC_BUG
         bool
-        depends on BUG
 
 config TIME_LOW_RES
 	bool
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 33a9792..f50cc8f 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -84,7 +84,6 @@ config STACKTRACE_SUPPORT
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG
 
 menu "Machine selection"
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 6507dab..5de1f8c 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -10,7 +10,6 @@ config PARISC
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
-	select BUG
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
@@ -62,7 +61,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_BUG
 	bool
 	default y
-	depends on BUG
 
 config GENERIC_HWEIGHT
 	bool
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c33e3ad..34f4ca9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -187,7 +187,6 @@ config AUDIT_ARCH
 config GENERIC_BUG
 	bool
 	default y
-	depends on BUG
 
 config SYS_SUPPORTS_APM_EMULATION
 	default y if PMAC_APM_EMU
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index da183c5..5d7b3db 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -29,7 +29,7 @@ config GENERIC_HWEIGHT
 	def_bool y
 
 config GENERIC_BUG
-	def_bool y if BUG
+	def_bool y
 
 config GENERIC_BUG_RELATIVE_POINTERS
 	def_bool y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 8c868cf..d555e7f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -84,7 +84,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG && SUPERH32
+	depends on SUPERH32
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index bceee66..7aae42a 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -53,7 +53,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_BUG
 	bool
 	default y
-	depends on BUG
 
 config HZ
 	int
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 723e42e..a36e1b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -166,7 +166,6 @@ config GENERIC_ISA_DMA
 
 config GENERIC_BUG
 	def_bool y
-	depends on BUG
 	select GENERIC_BUG_RELATIVE_POINTERS if X86_64
 
 config GENERIC_BUG_RELATIVE_POINTERS
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..5d50903 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -12,8 +12,6 @@
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
 
-#ifdef CONFIG_BUG
-
 #ifdef CONFIG_GENERIC_BUG
 struct bug_entry {
 #ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
@@ -106,33 +104,6 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_on);					\
 })
 
-#else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
-#endif
-
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
-#endif
-
-#ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
-
-#endif
-
 #define WARN_ON_ONCE(condition)	({				\
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
diff --git a/init/Kconfig b/init/Kconfig
index 7fb26a6..bc1dd49 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1360,16 +1360,6 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
-config BUG
-	bool "BUG() support" if EXPERT
-	default y
-	help
-          Disabling this option eliminates support for BUG and WARN, reducing
-          the size of your kernel image and potentially quietly ignoring
-          numerous fatal conditions. You should only consider disabling this
-          option for embedded systems with no facilities for reporting errors.
-          Just say Y.
-
 config ELF_CORE
 	depends on COREDUMP
 	default y
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..54b3251 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -700,7 +700,7 @@ config HAVE_DEBUG_BUGVERBOSE
 
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
-	depends on BUG && (GENERIC_BUG || HAVE_DEBUG_BUGVERBOSE)
+	depends on GENERIC_BUG || HAVE_DEBUG_BUGVERBOSE
 	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
-- 
1.7.7.6
