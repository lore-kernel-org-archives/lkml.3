Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3FXTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:47231 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FXTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 03/32] alpha: delete __cpuinit usage from all users
Date: Mon, 24 Jun 2013 15:30:08 -0400
Message-ID: <1372102237-8757-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the alpha uses of the __cpuinit macros.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/alpha/kernel/smp.c   | 10 +++++-----
 arch/alpha/kernel/traps.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 7b60834..53b18a6 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -116,7 +116,7 @@ wait_boot_cpu_to_stop(int cpuid)
 /*
  * Where secondaries begin a life of C.
  */
-void __cpuinit
+void
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
@@ -194,7 +194,7 @@ wait_for_txrdy (unsigned long cpumask)
  * Send a message to a secondary's console.  "START" is one such
  * interesting message.  ;-)
  */
-static void __cpuinit
+static void
 send_secondary_console_msg(char *str, int cpuid)
 {
 	struct percpu_struct *cpu;
@@ -285,7 +285,7 @@ recv_secondary_console_msg(void)
 /*
  * Convince the console to have a secondary cpu begin execution.
  */
-static int __cpuinit
+static int
 secondary_cpu_start(int cpuid, struct task_struct *idle)
 {
 	struct percpu_struct *cpu;
@@ -356,7 +356,7 @@ secondary_cpu_start(int cpuid, struct task_struct *idle)
 /*
  * Bring one cpu online.
  */
-static int __cpuinit
+static int
 smp_boot_one_cpu(int cpuid, struct task_struct *idle)
 {
 	unsigned long timeout;
@@ -472,7 +472,7 @@ smp_prepare_boot_cpu(void)
 {
 }
 
-int __cpuinit
+int
 __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	smp_boot_one_cpu(cpu, tidle);
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index affccb9..be1fba3 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -32,7 +32,7 @@
 
 static int opDEC_fix;
 
-static void __cpuinit
+static void
 opDEC_check(void)
 {
 	__asm__ __volatile__ (
@@ -1059,7 +1059,7 @@ give_sigbus:
 	return;
 }
 
-void __cpuinit
+void
 trap_init(void)
 {
 	/* Tell PAL-code what global pointer we want in the kernel.  */
-- 
1.8.1.2

