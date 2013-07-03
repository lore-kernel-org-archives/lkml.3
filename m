Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab3GCOlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:41:21 -0400
Received: from multi.imgtec.com ([194.200.65.239]:35873 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab3GCOlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:41:20 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Dave Jones" <davej@redhat.com>, David Howells <dhowells@redhat.com>,
        David Sharp <dhsharp@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, <linux-mips@linux-mips.org>
Subject: [PATCH] MIPS: use generic-y where possible
Date: Wed, 3 Jul 2013 15:40:58 +0100
Message-ID: <1372862458-22693-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_03_15_41_15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic-y and remove headers in arch/mips/include/[uapi/]asm/Kbuild
where the header just includes or is identical to the corresponding
<asm-generic/*.h>.

We can't do the same for uapi/asm/kvm_para.h because it's presence is
explicitly checked in include/uapi/linux/Kbuild to decide whether to add
kvm_para.h to header-y.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/Kbuild              | 13 +++++++++++++
 arch/mips/include/asm/cputime.h           |  6 ------
 arch/mips/include/asm/current.h           |  1 -
 arch/mips/include/asm/emergency-restart.h |  6 ------
 arch/mips/include/asm/local64.h           |  1 -
 arch/mips/include/asm/mutex.h             |  9 ---------
 arch/mips/include/asm/parport.h           |  1 -
 arch/mips/include/asm/percpu.h            |  6 ------
 arch/mips/include/asm/scatterlist.h       |  6 ------
 arch/mips/include/asm/sections.h          |  6 ------
 arch/mips/include/asm/segment.h           |  6 ------
 arch/mips/include/asm/serial.h            |  1 -
 arch/mips/include/asm/ucontext.h          |  1 -
 arch/mips/include/asm/xor.h               |  1 -
 arch/mips/include/uapi/asm/Kbuild         |  5 +++--
 arch/mips/include/uapi/asm/auxvec.h       |  4 ----
 arch/mips/include/uapi/asm/ipcbuf.h       |  1 -
 17 files changed, 16 insertions(+), 58 deletions(-)
 delete mode 100644 arch/mips/include/asm/cputime.h
 delete mode 100644 arch/mips/include/asm/current.h
 delete mode 100644 arch/mips/include/asm/emergency-restart.h
 delete mode 100644 arch/mips/include/asm/local64.h
 delete mode 100644 arch/mips/include/asm/mutex.h
 delete mode 100644 arch/mips/include/asm/parport.h
 delete mode 100644 arch/mips/include/asm/percpu.h
 delete mode 100644 arch/mips/include/asm/scatterlist.h
 delete mode 100644 arch/mips/include/asm/sections.h
 delete mode 100644 arch/mips/include/asm/segment.h
 delete mode 100644 arch/mips/include/asm/serial.h
 delete mode 100644 arch/mips/include/asm/ucontext.h
 delete mode 100644 arch/mips/include/asm/xor.h
 delete mode 100644 arch/mips/include/uapi/asm/auxvec.h
 delete mode 100644 arch/mips/include/uapi/asm/ipcbuf.h

diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 9b54b7a..454ddf9 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,2 +1,15 @@
 # MIPS headers
+generic-y += cputime.h
+generic-y += current.h
+generic-y += emergency-restart.h
+generic-y += local64.h
+generic-y += mutex.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += segment.h
+generic-y += serial.h
 generic-y += trace_clock.h
+generic-y += ucontext.h
+generic-y += xor.h
diff --git a/arch/mips/include/asm/cputime.h b/arch/mips/include/asm/cputime.h
deleted file mode 100644
index c00eacb..0000000
--- a/arch/mips/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __MIPS_CPUTIME_H
-#define __MIPS_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __MIPS_CPUTIME_H */
diff --git a/arch/mips/include/asm/current.h b/arch/mips/include/asm/current.h
deleted file mode 100644
index 4c51401..0000000
--- a/arch/mips/include/asm/current.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/current.h>
diff --git a/arch/mips/include/asm/emergency-restart.h b/arch/mips/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/mips/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/mips/include/asm/local64.h b/arch/mips/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/mips/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/mips/include/asm/mutex.h b/arch/mips/include/asm/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/arch/mips/include/asm/mutex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * Pull in the generic implementation for the mutex fastpath.
- *
- * TODO: implement optimized primitives instead, or leave the generic
- * implementation in place, or pick the atomic_xchg() based generic
- * implementation. (see asm-generic/mutex-xchg.h for details)
- */
-
-#include <asm-generic/mutex-dec.h>
diff --git a/arch/mips/include/asm/parport.h b/arch/mips/include/asm/parport.h
deleted file mode 100644
index cf252af..0000000
--- a/arch/mips/include/asm/parport.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/parport.h>
diff --git a/arch/mips/include/asm/percpu.h b/arch/mips/include/asm/percpu.h
deleted file mode 100644
index 844e763..0000000
--- a/arch/mips/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PERCPU_H
-#define __ASM_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif /* __ASM_PERCPU_H */
diff --git a/arch/mips/include/asm/scatterlist.h b/arch/mips/include/asm/scatterlist.h
deleted file mode 100644
index 7ee0e64..0000000
--- a/arch/mips/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_SCATTERLIST_H
-#define __ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* __ASM_SCATTERLIST_H */
diff --git a/arch/mips/include/asm/sections.h b/arch/mips/include/asm/sections.h
deleted file mode 100644
index b7e3726..0000000
--- a/arch/mips/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SECTIONS_H
-#define _ASM_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* _ASM_SECTIONS_H */
diff --git a/arch/mips/include/asm/segment.h b/arch/mips/include/asm/segment.h
deleted file mode 100644
index 92ac001..0000000
--- a/arch/mips/include/asm/segment.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SEGMENT_H
-#define _ASM_SEGMENT_H
-
-/* Only here because we have some old header files that expect it.. */
-
-#endif /* _ASM_SEGMENT_H */
diff --git a/arch/mips/include/asm/serial.h b/arch/mips/include/asm/serial.h
deleted file mode 100644
index a0cb0ca..0000000
--- a/arch/mips/include/asm/serial.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/serial.h>
diff --git a/arch/mips/include/asm/ucontext.h b/arch/mips/include/asm/ucontext.h
deleted file mode 100644
index 9bc07b9..0000000
--- a/arch/mips/include/asm/ucontext.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ucontext.h>
diff --git a/arch/mips/include/asm/xor.h b/arch/mips/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/mips/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/mips/include/uapi/asm/Kbuild b/arch/mips/include/uapi/asm/Kbuild
index 350cccc..be7196e 100644
--- a/arch/mips/include/uapi/asm/Kbuild
+++ b/arch/mips/include/uapi/asm/Kbuild
@@ -1,7 +1,9 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += auxvec.h
+generic-y += auxvec.h
+generic-y += ipcbuf.h
+
 header-y += bitsperlong.h
 header-y += break.h
 header-y += byteorder.h
@@ -11,7 +13,6 @@ header-y += fcntl.h
 header-y += inst.h
 header-y += ioctl.h
 header-y += ioctls.h
-header-y += ipcbuf.h
 header-y += kvm_para.h
 header-y += mman.h
 header-y += msgbuf.h
diff --git a/arch/mips/include/uapi/asm/auxvec.h b/arch/mips/include/uapi/asm/auxvec.h
deleted file mode 100644
index 7cf7f2d..0000000
--- a/arch/mips/include/uapi/asm/auxvec.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _ASM_AUXVEC_H
-#define _ASM_AUXVEC_H
-
-#endif /* _ASM_AUXVEC_H */
diff --git a/arch/mips/include/uapi/asm/ipcbuf.h b/arch/mips/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/mips/include/uapi/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.8.1.2


