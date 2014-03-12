Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaCLCKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:10:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:37633 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbaCLCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:10:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Archs <linux-arch@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/6] arch: Remove stub cputime.h headers
Date: Wed, 12 Mar 2014 03:10:02 +0100
Message-Id: <1394590202-772-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
References: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures have a stub cputime.h that only include the default
cputime.h

Lets remove the useless headers, we only need to mention that we want
the default headers on the Kbuild files.

Cc: Archs <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/alpha/include/asm/Kbuild         | 1 +
 arch/alpha/include/asm/cputime.h      | 6 ------
 arch/cris/include/asm/Kbuild          | 1 +
 arch/cris/include/asm/cputime.h       | 6 ------
 arch/frv/include/asm/Kbuild           | 1 +
 arch/frv/include/asm/cputime.h        | 6 ------
 arch/m32r/include/asm/Kbuild          | 1 +
 arch/m32r/include/asm/cputime.h       | 6 ------
 arch/microblaze/include/asm/Kbuild    | 1 +
 arch/microblaze/include/asm/cputime.h | 1 -
 arch/mn10300/include/asm/Kbuild       | 1 +
 arch/mn10300/include/asm/cputime.h    | 1 -
 arch/score/include/asm/Kbuild         | 2 +-
 arch/score/include/asm/cputime.h      | 6 ------
 arch/x86/include/asm/Kbuild           | 1 +
 arch/x86/include/asm/cputime.h        | 1 -
 16 files changed, 8 insertions(+), 34 deletions(-)
 delete mode 100644 arch/alpha/include/asm/cputime.h
 delete mode 100644 arch/cris/include/asm/cputime.h
 delete mode 100644 arch/frv/include/asm/cputime.h
 delete mode 100644 arch/m32r/include/asm/cputime.h
 delete mode 100644 arch/microblaze/include/asm/cputime.h
 delete mode 100644 arch/mn10300/include/asm/cputime.h
 delete mode 100644 arch/score/include/asm/cputime.h
 delete mode 100644 arch/x86/include/asm/cputime.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a73a8e2..1a81a8b 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += cputime.h
\ No newline at end of file
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
index f3fd876..9d02b45 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -14,3 +14,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += cputime.h
\ No newline at end of file
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
index bc42f14..c5eca98 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += cputime.h
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
index 932435a..fda061d 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += module.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += cputime.h
\ No newline at end of file
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
index 2b98bc7..da88738a 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += hash.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
 generic-y += preempt.h
+generic-y += cputime.h
diff --git a/arch/microblaze/include/asm/cputime.h b/arch/microblaze/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/microblaze/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 992e989..e076269 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += cputime.h
\ No newline at end of file
diff --git a/arch/mn10300/include/asm/cputime.h b/arch/mn10300/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/mn10300/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 146b9d5..1274e7a 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -7,4 +7,4 @@ generic-y += hash.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
-
+generic-y += cputime.h
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

