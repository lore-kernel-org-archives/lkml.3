Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaHLPtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:49:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52932 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHLPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:49:48 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 2/4] Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
Date: Tue, 12 Aug 2014 16:49:13 +0100
Message-Id: <1407858555-14371-3-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 12 Aug 2014 15:49:42.0985 (UTC) FILETIME=[08927B90:01CFB645]
X-MC-Unique: 114081216494611101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7CFntq7014537

Section 4 intro was still describing the old interface. Rewrite it.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Henrik Austad <henrik@austad.us>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/scheduler/sched-deadline.txt |   49 ++++++++++++++--------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index db25eb5..4acba51 100644
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
  and thus we don't need an higher level throttling mechanism to enforce the
- desired bandwidth.
+ desired bandwidth. Therefore, using this simple interface, we can put a cap
+ on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
+ some_desired_value).
 
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
-- 
1.7.9.5


