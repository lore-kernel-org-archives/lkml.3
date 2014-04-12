Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaDLJf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 05:35:56 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:33984 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbaDLJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:35:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAJsISVNbske0/2dsb2JhbABZgwaDUMBoAgKBFxd0gmYcFQ4YFW0QFBOIAAHMAI5uhD8Ejl+KAQGKZIdfgzM7
Date: Sat, 12 Apr 2014 11:37:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] sys_sgetmask/sys_ssetmask: Add CONFIG_SGETMASK_SYSCALL
Message-Id: <20140412113722.c670eaacb86b3cf0ae287815@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_sgetmask and sys_ssetmask are obsolete system calls no longer
supported in libc.

This patch replaces architecture related __ARCH_WANT_SYS_SGETMAX
by expert mode configuration.That option is enabled by default
for those architectures.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/blackfin/include/asm/unistd.h   |  1 -
 arch/cris/include/asm/unistd.h       |  1 -
 arch/frv/include/asm/unistd.h        |  1 -
 arch/m68k/include/asm/unistd.h       |  1 -
 arch/microblaze/include/asm/unistd.h |  1 -
 arch/mips/include/asm/unistd.h       |  1 -
 arch/mn10300/include/asm/unistd.h    |  1 -
 arch/parisc/include/asm/unistd.h     |  1 -
 arch/powerpc/include/asm/unistd.h    |  1 -
 arch/sh/include/asm/unistd.h         |  1 -
 arch/sparc/include/asm/unistd.h      |  1 -
 arch/x86/include/asm/unistd.h        |  1 -
 init/Kconfig                         | 10 ++++++++++
 kernel/signal.c                      |  4 ++--
 kernel/sys_ni.c                      |  2 ++
 15 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index c35414b..c8c8ff9 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -12,7 +12,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index 5cc7d19..0f40fed 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -15,7 +15,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index 70ec729..17b5df8 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -13,7 +13,6 @@
 /* #define __ARCH_WANT_SYS_GETHOSTNAME */
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-/* #define __ARCH_WANT_SYS_SGETMASK */
 /* #define __ARCH_WANT_SYS_SIGNAL */
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 9d38b73..6a43c16 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -13,7 +13,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index b14232b..fd56a8f 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -19,7 +19,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index 413d6c6..e558130 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -29,7 +29,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index 9d4e2d1..0522468 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -26,7 +26,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index 74d8358..5f4c68d 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -145,7 +145,6 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_TIME
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 4494f02..cadd550 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -29,7 +29,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/sh/include/asm/unistd.h b/arch/sh/include/asm/unistd.h
index e77816c..126fe83 100644
--- a/arch/sh/include/asm/unistd.h
+++ b/arch/sh/include/asm/unistd.h
@@ -11,7 +11,6 @@
 # define __ARCH_WANT_SYS_GETHOSTNAME
 # define __ARCH_WANT_SYS_IPC
 # define __ARCH_WANT_SYS_PAUSE
-# define __ARCH_WANT_SYS_SGETMASK
 # define __ARCH_WANT_SYS_SIGNAL
 # define __ARCH_WANT_SYS_TIME
 # define __ARCH_WANT_SYS_UTIME
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index dfa53fd..0aac1e8 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -25,7 +25,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 3f556c6..2b19caa 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -41,7 +41,6 @@
 # define __ARCH_WANT_SYS_OLD_GETRLIMIT
 # define __ARCH_WANT_SYS_OLD_UNAME
 # define __ARCH_WANT_SYS_PAUSE
-# define __ARCH_WANT_SYS_SGETMASK
 # define __ARCH_WANT_SYS_SIGNAL
 # define __ARCH_WANT_SYS_SIGPENDING
 # define __ARCH_WANT_SYS_SIGPROCMASK
diff --git a/init/Kconfig b/init/Kconfig
index 427ba60..b052613 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1301,6 +1301,16 @@ config UID16
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config SGETMASK_SYSCALL
+	bool "sgetmask/ssetmask syscalls support" if EXPERT
+	def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
+	---help---
+	  sys_sgetmask and sys_ssetmask are obsolete system calls
+	  no longer supported in libc but still enabled by default in some
+	  architectures.
+
+	  If unsure, leave the default option here.
+
 config SYSFS_SYSCALL
 	bool "Sysfs syscall support" if EXPERT
 	default y
diff --git a/kernel/signal.c b/kernel/signal.c
index 6ea13c0..6e600aaa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3496,7 +3496,7 @@ COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
 }
 #endif
 
-#ifdef __ARCH_WANT_SYS_SGETMASK
+#ifdef CONFIG_SGETMASK_SYSCALL
 
 /*
  * For backwards compatibility.  Functionality superseded by sigprocmask.
@@ -3517,7 +3517,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 
 	return old;
 }
-#endif /* __ARCH_WANT_SGETMASK */
+#endif /* CONFIG_SGETMASK_SYSCALL */
 
 #ifdef __ARCH_WANT_SYS_SIGNAL
 /*
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bc8d1b7..36441b5 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -135,6 +135,8 @@ cond_syscall(sys_setresgid16);
 cond_syscall(sys_setresuid16);
 cond_syscall(sys_setreuid16);
 cond_syscall(sys_setuid16);
+cond_syscall(sys_sgetmask);
+cond_syscall(sys_ssetmask);
 cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
 cond_syscall(sys_ipc);
-- 
1.8.4.5

