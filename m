Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaAWS1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:27:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:48850 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAWS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:27:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] arm64: delete non-required instances of <linux/init.h>
Date: Thu, 23 Jan 2014 13:26:51 -0500
Message-ID: <1390501611-31691-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one place to the next.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Build tested on today's linux-next ; thanks to Will for the pointer
 to a prebuilt toolchain.  Patch to be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git   ]

 arch/arm64/include/asm/arch_timer.h | 1 -
 arch/arm64/kernel/cputable.c        | 2 --
 arch/arm64/kernel/entry.S           | 1 -
 arch/arm64/kernel/hyp-stub.S        | 1 -
 arch/arm64/kernel/process.c         | 1 -
 arch/arm64/kernel/ptrace.c          | 1 -
 arch/arm64/kernel/smp_spin_table.c  | 1 -
 arch/arm64/kernel/vdso/vdso.S       | 1 -
 arch/arm64/lib/delay.c              | 1 -
 arch/arm64/mm/cache.S               | 1 -
 arch/arm64/mm/proc.S                | 1 -
 11 files changed, 12 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596a0f39..c4a14de68523 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -21,7 +21,6 @@
 
 #include <asm/barrier.h>
 
-#include <linux/init.h>
 #include <linux/types.h>
 
 #include <clocksource/arm_arch_timer.h>
diff --git a/arch/arm64/kernel/cputable.c b/arch/arm64/kernel/cputable.c
index fd3993cb060f..e1a39fcf2433 100644
--- a/arch/arm64/kernel/cputable.c
+++ b/arch/arm64/kernel/cputable.c
@@ -16,8 +16,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/init.h>
-
 #include <asm/cputable.h>
 
 extern unsigned long __cpu_setup(void);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 39ac630d83de..3d255b05c48a 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -18,7 +18,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/init.h>
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 0959611d9ff1..066d366cc850 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -17,7 +17,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/init.h>
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 248a15db37f2..1e5a17811648 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -31,7 +31,6 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
-#include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/elfcore.h>
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928bba03c..8bde301f926f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/security.h>
-#include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/uaccess.h>
 #include <linux/perf_event.h>
diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index 44c22805d2e2..56a82775c612 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/of.h>
 #include <linux/smp.h>
 
diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
index 60c1db54b41a..662e53dbbb60 100644
--- a/arch/arm64/kernel/vdso/vdso.S
+++ b/arch/arm64/kernel/vdso/vdso.S
@@ -16,7 +16,6 @@
  * Author: Will Deacon <will.deacon@arm.com>
  */
 
-#include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/const.h>
 #include <asm/page.h>
diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index dad4ec9bbfd1..11030dab2dc6 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timex.h>
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 48a386094fa3..035a5a837287 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -18,7 +18,6 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/assembler.h>
 
 #include "proc-macros.S"
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index bed1f1de1caf..18a5f10417fd 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -18,7 +18,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
-- 
1.8.5.2

