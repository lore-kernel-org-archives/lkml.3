Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaAUVkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:40:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:56351 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaAUVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, <linux-alpha@vger.kernel.org>
Subject: [PATCH 37/73] alpha: delete non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:40 -0500
Message-ID: <1390339396-3479-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/alpha/kernel/err_ev6.c         | 1 -
 arch/alpha/kernel/irq.c             | 1 -
 arch/alpha/kernel/traps.c           | 1 -
 arch/alpha/oprofile/op_model_ev4.c  | 1 -
 arch/alpha/oprofile/op_model_ev5.c  | 1 -
 arch/alpha/oprofile/op_model_ev6.c  | 1 -
 arch/alpha/oprofile/op_model_ev67.c | 1 -
 7 files changed, 7 deletions(-)

diff --git a/arch/alpha/kernel/err_ev6.c b/arch/alpha/kernel/err_ev6.c
index 253cf1a..51267ac 100644
--- a/arch/alpha/kernel/err_ev6.c
+++ b/arch/alpha/kernel/err_ev6.c
@@ -6,7 +6,6 @@
  *	Error handling code supporting Alpha systems
  */
 
-#include <linux/init.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 7b2be25..51f2c86 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -19,7 +19,6 @@
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
 #include <linux/random.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 9c4c189..74aceea 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -14,7 +14,6 @@
 #include <linux/tty.h>
 #include <linux/delay.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/ratelimit.h>
 
diff --git a/arch/alpha/oprofile/op_model_ev4.c b/arch/alpha/oprofile/op_model_ev4.c
index 18aa9b4..086a0d5 100644
--- a/arch/alpha/oprofile/op_model_ev4.c
+++ b/arch/alpha/oprofile/op_model_ev4.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/oprofile.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
 
diff --git a/arch/alpha/oprofile/op_model_ev5.c b/arch/alpha/oprofile/op_model_ev5.c
index c32f8a0..c300f5e 100644
--- a/arch/alpha/oprofile/op_model_ev5.c
+++ b/arch/alpha/oprofile/op_model_ev5.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/oprofile.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
 
diff --git a/arch/alpha/oprofile/op_model_ev6.c b/arch/alpha/oprofile/op_model_ev6.c
index 1c84cc2..02edf59 100644
--- a/arch/alpha/oprofile/op_model_ev6.c
+++ b/arch/alpha/oprofile/op_model_ev6.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/oprofile.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
 
diff --git a/arch/alpha/oprofile/op_model_ev67.c b/arch/alpha/oprofile/op_model_ev67.c
index 34a57a1..adb1744 100644
--- a/arch/alpha/oprofile/op_model_ev67.c
+++ b/arch/alpha/oprofile/op_model_ev67.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/oprofile.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
 
-- 
1.8.4.1

