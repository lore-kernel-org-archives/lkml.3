Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3KHDpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:45:23 -0500
Received: from intranet.asianux.com ([58.214.24.6]:2942 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3KHDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:45:20 -0500
X-Spam-Score: -100.8
Message-ID: <527C5ECD.8010208@asianux.com>
Date: Fri, 08 Nov 2013 11:47:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH] arch: arm: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installer.sh").

Additional completions:

 - be sure that all "endif" need be appended related comment, also it
   has and only has one empty line above and no any lines below either.

 - be sure that all normal uapi header files need content guard macro.

 - remove the default "kvm_para.h" which was added in Kbuild.

 - remove the detail address of Free Software Foundation (or can not
   pass "scripts/checkpatch.pl").


Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/include/uapi/asm/byteorder.h   |    7 +++----
 arch/arm/include/uapi/asm/fcntl.h       |    6 +++---
 arch/arm/include/uapi/asm/ioctls.h      |    6 +++---
 arch/arm/include/uapi/asm/kvm.h         |    8 ++++----
 arch/arm/include/uapi/asm/kvm_para.h    |    1 -
 arch/arm/include/uapi/asm/mman.h        |    5 +++++
 arch/arm/include/uapi/asm/perf_regs.h   |    7 ++++---
 arch/arm/include/uapi/asm/posix_types.h |    6 +++---
 arch/arm/include/uapi/asm/ptrace.h      |    1 -
 arch/arm/include/uapi/asm/setup.h       |    1 -
 arch/arm/include/uapi/asm/sigcontext.h  |    7 +++----
 arch/arm/include/uapi/asm/signal.h      |    1 -
 arch/arm/include/uapi/asm/stat.h        |    6 +++---
 arch/arm/include/uapi/asm/statfs.h      |    7 ++++---
 14 files changed, 35 insertions(+), 34 deletions(-)
 delete mode 100644 arch/arm/include/uapi/asm/kvm_para.h

diff --git a/arch/arm/include/uapi/asm/byteorder.h b/arch/arm/include/uapi/asm/byteorder.h
index 7737974..ffd1e93 100644
--- a/arch/arm/include/uapi/asm/byteorder.h
+++ b/arch/arm/include/uapi/asm/byteorder.h
@@ -12,8 +12,8 @@
  * and word accesses (data or instruction) appear as:
  *  d0...d31
  */
-#ifndef __ASM_ARM_BYTEORDER_H
-#define __ASM_ARM_BYTEORDER_H
+#ifndef _UAPI__ASM_ARM_BYTEORDER_H
+#define _UAPI__ASM_ARM_BYTEORDER_H
 
 #ifdef __ARMEB__
 #include <linux/byteorder/big_endian.h>
@@ -21,5 +21,4 @@
 #include <linux/byteorder/little_endian.h>
 #endif
 
-#endif
-
+#endif /* _UAPI__ASM_ARM_BYTEORDER_H */
diff --git a/arch/arm/include/uapi/asm/fcntl.h b/arch/arm/include/uapi/asm/fcntl.h
index a80b660..4cde9c4 100644
--- a/arch/arm/include/uapi/asm/fcntl.h
+++ b/arch/arm/include/uapi/asm/fcntl.h
@@ -1,5 +1,5 @@
-#ifndef _ARM_FCNTL_H
-#define _ARM_FCNTL_H
+#ifndef _UAPI_ARM_FCNTL_H
+#define _UAPI_ARM_FCNTL_H
 
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
@@ -8,4 +8,4 @@
 
 #include <asm-generic/fcntl.h>
 
-#endif
+#endif /* _UAPI_ARM_FCNTL_H */
diff --git a/arch/arm/include/uapi/asm/ioctls.h b/arch/arm/include/uapi/asm/ioctls.h
index 9c96298..a9d8008 100644
--- a/arch/arm/include/uapi/asm/ioctls.h
+++ b/arch/arm/include/uapi/asm/ioctls.h
@@ -1,8 +1,8 @@
-#ifndef __ASM_ARM_IOCTLS_H
-#define __ASM_ARM_IOCTLS_H
+#ifndef _UAPI__ASM_ARM_IOCTLS_H
+#define _UAPI__ASM_ARM_IOCTLS_H
 
 #define FIOQSIZE	0x545E
 
 #include <asm-generic/ioctls.h>
 
-#endif
+#endif /* _UAPI__ASM_ARM_IOCTLS_H */
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index c498b60..f44fad1 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -13,11 +13,11 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * Foundation (the address is in a copy of the GPL).
  */
 
-#ifndef __ARM_KVM_H__
-#define __ARM_KVM_H__
+#ifndef _UAPI__ARM_KVM_H__
+#define _UAPI__ARM_KVM_H__
 
 #include <linux/types.h>
 #include <asm/ptrace.h>
@@ -178,4 +178,4 @@ struct kvm_arch_memory_slot {
 #define KVM_PSCI_RET_INVAL		((unsigned long)-2)
 #define KVM_PSCI_RET_DENIED		((unsigned long)-3)
 
-#endif /* __ARM_KVM_H__ */
+#endif /* _UAPI__ARM_KVM_H__ */
diff --git a/arch/arm/include/uapi/asm/kvm_para.h b/arch/arm/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/arm/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/arm/include/uapi/asm/mman.h b/arch/arm/include/uapi/asm/mman.h
index 41f99c5..bf6ac7c 100644
--- a/arch/arm/include/uapi/asm/mman.h
+++ b/arch/arm/include/uapi/asm/mman.h
@@ -1,4 +1,9 @@
+#ifndef _UAPI_ARM_MMAN_H
+#define _UAPI_ARM_MMAN_H
+
 #include <asm-generic/mman.h>
 
 #define arch_mmap_check(addr, len, flags) \
 	(((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)
+
+#endif /* _UAPI_ARM_MMAN_H */
diff --git a/arch/arm/include/uapi/asm/perf_regs.h b/arch/arm/include/uapi/asm/perf_regs.h
index ce59448..61e86fb 100644
--- a/arch/arm/include/uapi/asm/perf_regs.h
+++ b/arch/arm/include/uapi/asm/perf_regs.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_ARM_PERF_REGS_H
-#define _ASM_ARM_PERF_REGS_H
+#ifndef _UAPI_ASM_ARM_PERF_REGS_H
+#define _UAPI_ASM_ARM_PERF_REGS_H
 
 enum perf_event_arm_regs {
 	PERF_REG_ARM_R0,
@@ -20,4 +20,5 @@ enum perf_event_arm_regs {
 	PERF_REG_ARM_PC,
 	PERF_REG_ARM_MAX,
 };
-#endif /* _ASM_ARM_PERF_REGS_H */
+
+#endif /* _UAPI_ASM_ARM_PERF_REGS_H */
diff --git a/arch/arm/include/uapi/asm/posix_types.h b/arch/arm/include/uapi/asm/posix_types.h
index d2de9cb..d0e3856 100644
--- a/arch/arm/include/uapi/asm/posix_types.h
+++ b/arch/arm/include/uapi/asm/posix_types.h
@@ -10,8 +10,8 @@
  *  Changelog:
  *   27-06-1996	RMK	Created
  */
-#ifndef __ARCH_ARM_POSIX_TYPES_H
-#define __ARCH_ARM_POSIX_TYPES_H
+#ifndef _UAPI__ARCH_ARM_POSIX_TYPES_H
+#define _UAPI__ARCH_ARM_POSIX_TYPES_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -34,4 +34,4 @@ typedef unsigned short		__kernel_old_dev_t;
 
 #include <asm-generic/posix_types.h>
 
-#endif
+#endif /* _UAPI__ARCH_ARM_POSIX_TYPES_H */
diff --git a/arch/arm/include/uapi/asm/ptrace.h b/arch/arm/include/uapi/asm/ptrace.h
index 5af0ed1..9fd79dd 100644
--- a/arch/arm/include/uapi/asm/ptrace.h
+++ b/arch/arm/include/uapi/asm/ptrace.h
@@ -151,7 +151,6 @@ struct pt_regs {
  */
 #define ARM_VFPREGS_SIZE ( 32 * 8 /*fpregs*/ + 4 /*fpscr*/ )
 
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI__ASM_ARM_PTRACE_H */
diff --git a/arch/arm/include/uapi/asm/setup.h b/arch/arm/include/uapi/asm/setup.h
index 979ff40..be889f3 100644
--- a/arch/arm/include/uapi/asm/setup.h
+++ b/arch/arm/include/uapi/asm/setup.h
@@ -183,5 +183,4 @@ struct tagtable {
 #define for_each_tag(t,base)		\
 	for (t = base; t->hdr.size; t = tag_next(t))
 
-
 #endif /* _UAPI__ASMARM_SETUP_H */
diff --git a/arch/arm/include/uapi/asm/sigcontext.h b/arch/arm/include/uapi/asm/sigcontext.h
index fc0b80b..f6aa372 100644
--- a/arch/arm/include/uapi/asm/sigcontext.h
+++ b/arch/arm/include/uapi/asm/sigcontext.h
@@ -1,5 +1,5 @@
-#ifndef _ASMARM_SIGCONTEXT_H
-#define _ASMARM_SIGCONTEXT_H
+#ifndef _UAPI_ASMARM_SIGCONTEXT_H
+#define _UAPI_ASMARM_SIGCONTEXT_H
 
 /*
  * Signal context structure - contains all info to do with the state
@@ -30,5 +30,4 @@ struct sigcontext {
 	unsigned long fault_address;
 };
 
-
-#endif
+#endif /* _UAPI_ASMARM_SIGCONTEXT_H */
diff --git a/arch/arm/include/uapi/asm/signal.h b/arch/arm/include/uapi/asm/signal.h
index 33073bd..8954e9a 100644
--- a/arch/arm/include/uapi/asm/signal.h
+++ b/arch/arm/include/uapi/asm/signal.h
@@ -116,5 +116,4 @@ typedef struct sigaltstack {
 	size_t ss_size;
 } stack_t;
 
-
 #endif /* _UAPI_ASMARM_SIGNAL_H */
diff --git a/arch/arm/include/uapi/asm/stat.h b/arch/arm/include/uapi/asm/stat.h
index 42c0c13..57addf5 100644
--- a/arch/arm/include/uapi/asm/stat.h
+++ b/arch/arm/include/uapi/asm/stat.h
@@ -1,5 +1,5 @@
-#ifndef _ASMARM_STAT_H
-#define _ASMARM_STAT_H
+#ifndef _UAPI_ASMARM_STAT_H
+#define _UAPI_ASMARM_STAT_H
 
 struct __old_kernel_stat {
 	unsigned short st_dev;
@@ -84,4 +84,4 @@ struct stat64 {
 	unsigned long long	st_ino;
 };
 
-#endif
+#endif /* _UAPI_ASMARM_STAT_H */
diff --git a/arch/arm/include/uapi/asm/statfs.h b/arch/arm/include/uapi/asm/statfs.h
index 079447c..ebcb391 100644
--- a/arch/arm/include/uapi/asm/statfs.h
+++ b/arch/arm/include/uapi/asm/statfs.h
@@ -1,5 +1,5 @@
-#ifndef _ASMARM_STATFS_H
-#define _ASMARM_STATFS_H
+#ifndef _UAPI_ASMARM_STATFS_H
+#define _UAPI_ASMARM_STATFS_H
 
 /*
  * With EABI there is 4 bytes of padding added to this structure.
@@ -9,4 +9,5 @@
 #define ARCH_PACK_STATFS64 __attribute__((packed,aligned(4)))
 
 #include <asm-generic/statfs.h>
-#endif
+
+#endif /* _UAPI_ASMARM_STATFS_H */
-- 
1.7.7.6
