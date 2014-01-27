Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaA0GYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:24:21 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51663 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaA0GYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:24:17 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 01:24:12 EST
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 9/9] cpu/idle.c: move to sched/idle.c
Date: Mon, 27 Jan 2014 01:08:24 -0500
Message-id: <1390802904-28399-10-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integration of cpuidle with the scheduler requires that the idle loop be
closely integrated with the scheduler proper. Moving cpu/idle.c into the
sched directory will allow for a smoother integration, and eliminate a
subdirectory which contained only one source file.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/Makefile              | 1 -
 kernel/cpu/Makefile          | 1 -
 kernel/sched/Makefile        | 2 +-
 kernel/{cpu => sched}/idle.c | 0
 4 files changed, 1 insertion(+), 3 deletions(-)
 delete mode 100644 kernel/cpu/Makefile
 rename kernel/{cpu => sched}/idle.c (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee272..6f1c7e5cfc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,7 +22,6 @@ obj-y += sched/
 obj-y += locking/
 obj-y += power/
 obj-y += printk/
-obj-y += cpu/
 obj-y += irq/
 obj-y += rcu/
 
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
deleted file mode 100644
index 59ab052ef7..0000000000
--- a/kernel/cpu/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-y	= idle.o
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 7b621409cf..ac3e0ea68f 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o proc.o clock.o cputime.o idle_task.o idle.o fair.o rt.o stop_task.o
 obj-y += wait.o completion.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
diff --git a/kernel/cpu/idle.c b/kernel/sched/idle.c
similarity index 100%
rename from kernel/cpu/idle.c
rename to kernel/sched/idle.c
-- 
1.8.4.108.g55ea5f6

