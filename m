Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaCMKRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:17:44 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41239 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbaCMKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:41 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arndb@arndb.de
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 3/3] arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h
Date: Thu, 13 Mar 2014 19:17:03 +0900
Message-Id: <1394705823-12465-4-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/seccomp.c includes linux/compat.h and, indicrectly, asm/compat.h
via asm/syscall.h. Due to the duplicated definitions of is_compat_task,
compiling this file will fail in the case of !CONFIG_COMPAT.
So this patch
1) removes is_compat_task() definition from asm/compat.h
2) replaces asm/compat.h to linux/compat.h in kernel/*.c

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/compat.h   |    5 -----
 arch/arm64/kernel/hw_breakpoint.c |    2 +-
 arch/arm64/kernel/process.c       |    2 +-
 arch/arm64/kernel/ptrace.c        |    2 +-
 arch/arm64/kernel/signal.c        |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..3b334f9 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -305,11 +305,6 @@ static inline int is_compat_thread(struct thread_info *thread)
 
 #else /* !CONFIG_COMPAT */
 
-static inline int is_compat_task(void)
-{
-	return 0;
-}
-
 static inline int is_compat_thread(struct thread_info *thread)
 {
 	return 0;
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index f17f581..a45e2db 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -20,6 +20,7 @@
 
 #define pr_fmt(fmt) "hw-breakpoint: " fmt
 
+#include <linux/compat.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hw_breakpoint.h>
@@ -27,7 +28,6 @@
 #include <linux/ptrace.h>
 #include <linux/smp.h>
 
-#include <asm/compat.h>
 #include <asm/current.h>
 #include <asm/debug-monitors.h>
 #include <asm/hw_breakpoint.h>
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1c0a9be..02eefc6 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -20,6 +20,7 @@
 
 #include <stdarg.h>
 
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -44,7 +45,6 @@
 #include <linux/personality.h>
 #include <linux/notifier.h>
 
-#include <asm/compat.h>
 #include <asm/cacheflush.h>
 #include <asm/fpsimd.h>
 #include <asm/mmu_context.h>
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index be2bb4c..674bae2 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/audit.h>
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -38,7 +39,6 @@
 #include <linux/tracehook.h>
 #include <linux/elf.h>
 
-#include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
 #include <asm/syscall.h>
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..4a09989 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -17,6 +17,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
@@ -25,7 +26,6 @@
 #include <linux/tracehook.h>
 #include <linux/ratelimit.h>
 
-#include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
-- 
1.7.9.5

