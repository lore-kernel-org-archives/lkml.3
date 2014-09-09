Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaIIJ7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:59:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42967 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbaIIJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:07 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
Date: Tue,  9 Sep 2014 10:57:13 +0100
Message-Id: <1410256636-26171-3-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 09 Sep 2014 09:57:03.0127 (UTC) FILETIME=[67E16270:01CFCC14]
X-MC-Unique: 114090910570516601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s899xuD0005230

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
-- 
2.0.4


