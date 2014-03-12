Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaCLQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:23:36 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44037 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCLQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:23:34 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Archs <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] arch: Remove stub cputime.h headers
Date: Wed, 12 Mar 2014 17:23:27 +0100
Message-Id: <1394641407-13964-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20140312094447.GP30956@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures have a stub cputime.h that only include the default
cputime.h

Lets remove the useless headers, we only need to mention that we want
the default headers on the Kbuild files.

While at it, resort alphabetically the entries in arch/*/include/asm/Kbuild
for those that have been touched. For this we use the script in commit
b119fa61d440f as suggested by Peter Zijlstra.

Cc: Archs <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/alpha/include/asm/Kbuild         | 7 ++++---
 arch/alpha/include/asm/cputime.h      | 6 ------
 arch/cris/include/asm/Kbuild          | 3 ++-
 arch/cris/include/asm/cputime.h       | 6 ------
 arch/frv/include/asm/Kbuild           | 5 +++--
 arch/frv/include/asm/cputime.h        | 6 ------
 arch/m32r/include/asm/Kbuild          | 5 +++--
 arch/m32r/include/asm/cputime.h       | 6 ------
 arch/microblaze/include/asm/Kbuild    | 5 +++--
 arch/microblaze/include/asm/cputime.h | 1 -
 arch/mn10300/include/asm/Kbuild       | 3 ++-
 arch/mn10300/include/asm/cputime.h    | 1 -
 arch/score/include/asm/Kbuild         | 4 ++--
 arch/score/include/asm/cputime.h      | 6 ------
 arch/x86/include/asm/Kbuild           | 1 +
 arch/x86/include/asm/cputime.h        | 1 -
 16 files changed, 20 insertions(+), 46 deletions(-)
 delete mode 100644 arch/alpha/include/asm/cputime.h
 delete mode 100644 arch/cris/include/asm/cputime.h
 delete mode 100644 arch/frv/include/asm/cputime.h
 delete mode 100644 arch/m32r/include/asm/cputime.h
 delete mode 100644 arch/microblaze/include/asm/cputime.h
 delete mode 100644 arch/mn10300/include/asm/cputime.h
 delete mode 100644 arch/score/include/asm/cputime.h
 delete mode 100644 arch/x86/include/asm/cputime.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a73a8e2..2d960be 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
-generic-y += clkdev.h
 
+generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
-generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += hash.h
+generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/alpha/include/asm/cputime.h b/arch/alpha/include/asm/cputime.h
deleted file mode 100644
index 19577fd..0000000
--- a/arch/alpha/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ALPHA_CPUTIME_H
-#define __ALPHA_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __ALPHA_CPUTIME_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index f3fd876..197199e 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -5,12 +5,13 @@ header-y += arch-v32/
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += module.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/cris/include/asm/cputime.h b/arch/cris/include/asm/cputime.h
deleted file mode 100644
index 4446a65..0000000
--- a/arch/cris/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __CRIS_CPUTIME_H
-#define __CRIS_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __CRIS_CPUTIME_H */
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index bc42f14..7b0940e 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
-generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += hash.h
+generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/frv/include/asm/cputime.h b/arch/frv/include/asm/cputime.h
deleted file mode 100644
index f6c373a..0000000
--- a/arch/frv/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUTIME_H
-#define _ASM_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_CPUTIME_H */
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 932435a..a46ff18 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
+generic-y += hash.h
 generic-y += module.h
-generic-y += trace_clock.h
 generic-y += preempt.h
-generic-y += hash.h
+generic-y += trace_clock.h
diff --git a/arch/m32r/include/asm/cputime.h b/arch/m32r/include/asm/cputime.h
deleted file mode 100644
index 0a47550..0000000
--- a/arch/m32r/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __M32R_CPUTIME_H
-#define __M32R_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __M32R_CPUTIME_H */
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 2b98bc7..12c7194 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,8 +1,9 @@
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += trace_clock.h
-generic-y += syscalls.h
 generic-y += preempt.h
+generic-y += syscalls.h
+generic-y += trace_clock.h
diff --git a/arch/microblaze/include/asm/cputime.h b/arch/microblaze/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/microblaze/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 992e989..b25a7d5 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/mn10300/include/asm/cputime.h b/arch/mn10300/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/mn10300/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 146b9d5..f1361618 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -3,8 +3,8 @@ header-y +=
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += hash.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += xor.h
-generic-y += preempt.h
-
diff --git a/arch/score/include/asm/cputime.h b/arch/score/include/asm/cputime.h
deleted file mode 100644
index 1fced99..0000000
--- a/arch/score/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_CPUTIME_H
-#define _ASM_SCORE_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_SCORE_CPUTIME_H */
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 7f66985..875f34e 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += cputime.h
diff --git a/arch/x86/include/asm/cputime.h b/arch/x86/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/x86/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
-- 
1.8.3.1

