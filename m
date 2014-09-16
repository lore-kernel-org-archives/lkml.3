Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaIPK6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:58:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43678 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaIPK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:34 -0400
Date: Tue, 16 Sep 2014 03:57:03 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-0d9ba8b03cfaed2696de42fe15ed410ba2ec7dbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luca.abeni@unitn.it, hpa@zytor.com,
        mingo@kernel.org, henrik@austad.us, torvalds@linux-foundation.org,
        peterz@infradead.org, rdunlap@infradead.org, raistlin@linux.it,
        juri.lelli@arm.com, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, henrik@austad.us,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1410256636-26171-3-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-3-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Documentation/scheduler/sched-deadline.txt:
  Rewrite section 4 intro
Git-Commit-ID: 0d9ba8b03cfaed2696de42fe15ed410ba2ec7dbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d9ba8b03cfaed2696de42fe15ed410ba2ec7dbe
Gitweb:     http://git.kernel.org/tip/0d9ba8b03cfaed2696de42fe15ed410ba2ec7dbe
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Tue, 9 Sep 2014 10:57:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:23:01 +0200

Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro

Section 4 intro was still describing the old interface. Rewrite
it.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Reviewed-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410256636-26171-3-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-deadline.txt | 51 +++++++++++++++---------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index a029891..f75d832 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -165,39 +165,38 @@ CONTENTS
 
  In order for the -deadline scheduling to be effective and useful, it is
  important to have some method to keep the allocation of the available CPU
- bandwidth to the tasks under control.
- This is usually called "admission control" and if it is not performed at all,
- no guarantee can be given on the actual scheduling of the -deadline tasks.
-
- Since when RT-throttling has been introduced each task group has a bandwidth
- associated, calculated as a certain amount of runtime over a period.
- Moreover, to make it possible to manipulate such bandwidth, readable/writable
- controls have been added to both procfs (for system wide settings) and cgroupfs
- (for per-group settings).
- Therefore, the same interface is being used for controlling the bandwidth
- distrubution to -deadline tasks.
-
- However, more discussion is needed in order to figure out how we want to manage
- SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
- uses (for now) a less sophisticated, but actually very sensible, mechanism to
- ensure that a certain utilization cap is not overcome per each root_domain.
-
- Another main difference between deadline bandwidth management and RT-throttling
+ bandwidth to the tasks under control. This is usually called "admission
+ control" and if it is not performed at all, no guarantee can be given on
+ the actual scheduling of the -deadline tasks.
+
+ The interface used to control the fraction of CPU bandwidth that can be
+ allocated to -deadline tasks is similar to the one already used for -rt
+ tasks with real-time group scheduling (a.k.a. RT-throttling - see
+ Documentation/scheduler/sched-rt-group.txt), and is based on readable/
+ writable control files located in procfs (for system wide settings).
+ Notice that per-group settings (controlled through cgroupfs) are still not
+ defined for -deadline tasks, because more discussion is needed in order to
+ figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
+ level.
+
+ A main difference between deadline bandwidth management and RT-throttling
  is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
- and thus we don't need an higher level throttling mechanism to enforce the
- desired bandwidth.
+ and thus we don't need a higher level throttling mechanism to enforce the
+ desired bandwidth. Therefore, using this simple interface we can put a cap
+ on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
+ global_dl_utilization_cap).
 
 4.1 System wide settings
 ------------------------
 
  The system wide settings are configured under the /proc virtual file system.
 
- For now the -rt knobs are used for dl admission control and the -deadline
- runtime is accounted against the -rt runtime. We realise that this isn't
- entirely desirable; however, it is better to have a small interface for now,
- and be able to change it easily later. The ideal situation (see 5.) is to run
- -rt tasks from a -deadline server; in which case the -rt bandwidth is a direct
- subset of dl_bw.
+ For now the -rt knobs are used for -deadline admission control and the
+ -deadline runtime is accounted against the -rt runtime. We realise that this
+ isn't entirely desirable; however, it is better to have a small interface for
+ now, and be able to change it easily later. The ideal situation (see 5.) is to
+ run -rt tasks from a -deadline server; in which case the -rt bandwidth is a
+ direct subset of dl_bw.
 
  This means that, for a root_domain comprising M CPUs, -deadline tasks
  can be created while the sum of their bandwidths stays below:
