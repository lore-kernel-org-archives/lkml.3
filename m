Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaB0MjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:39:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45340 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaB0MjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:39:10 -0500
Date: Thu, 27 Feb 2014 18:06:51 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, josh@joshtriplett.org
Subject: [PATCH 45/46] kernel: Move prototype declaration to header file
 include/linux/sched.h from init/main.c
Message-ID: <14a2e98b318cdefa161fbfed220d566599ec7f89.1393493278.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/sched.h from init/main.c because it is used by more than
one file.

This eliminates the following warning in kernel/fork.c:
kernel/fork.c:252:13: warning: no previous prototype for ‘fork_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/sched.h |    1 +
 init/main.c           |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d162e3b..f08958b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -161,6 +161,7 @@ extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 	load += n*(FIXED_1-exp); \
 	load >>= FSHIFT;
 
+void fork_init(unsigned long mempages);
 extern unsigned long total_forks;
 extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
diff --git a/init/main.c b/init/main.c
index eb03090..48929e3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -91,7 +91,6 @@
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
-extern void fork_init(unsigned long);
 extern void radix_tree_init(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
-- 
1.7.9.5

