Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaIPK6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:58:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaIPK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:34 -0400
Date: Tue, 16 Sep 2014 03:56:45 -0700
From: tip-bot for Luca Abeni <tipbot@zytor.com>
Message-ID: <tip-ad67dc316f000df4756b027f3559ad0491497d9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luca.abeni@unitn.it, hpa@zytor.com,
        mingo@kernel.org, henrik@austad.us, torvalds@linux-foundation.org,
        peterz@infradead.org, rdunlap@infradead.org, raistlin@linux.it,
        juri.lelli@arm.com, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, henrik@austad.us,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1410256636-26171-2-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-2-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Documentation/scheduler/sched-deadline.txt:
  Fix terminology and improve clarity
Git-Commit-ID: ad67dc316f000df4756b027f3559ad0491497d9e
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

Commit-ID:  ad67dc316f000df4756b027f3559ad0491497d9e
Gitweb:     http://git.kernel.org/tip/ad67dc316f000df4756b027f3559ad0491497d9e
Author:     Luca Abeni <luca.abeni@unitn.it>
AuthorDate: Tue, 9 Sep 2014 10:57:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:23:00 +0200

Documentation/scheduler/sched-deadline.txt: Fix terminology and improve clarity

Several small changes regarding SCHED_DEADLINE documentation
that fix terminology and improve clarity and readability:

 - "current runtime" becomes "remaining runtime"

 - readablity of an equation is improved by introducing more spacing

 - clarify when admission control will certainly fail

 - new URL for CBS technical report

 - substitue "smallest" with "earliest"

Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reviewed-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410256636-26171-2-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-deadline.txt | 38 ++++++++++++++++--------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index 18adc92..a029891 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -45,17 +45,17 @@ CONTENTS
  every time the task wakes up, the scheduler computes a "scheduling deadline"
  consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are then
  scheduled using EDF[1] on these scheduling deadlines (the task with the
- smallest scheduling deadline is selected for execution). Notice that this
+ earliest scheduling deadline is selected for execution). Notice that this
  guaranteed is respected if a proper "admission control" strategy (see Section
  "4. Bandwidth management") is used.
 
  Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
  that each task runs for at most its runtime every period, avoiding any
  interference between different tasks (bandwidth isolation), while the EDF[1]
- algorithm selects the task with the smallest scheduling deadline as the one
- to be executed first.  Thanks to this feature, also tasks that do not
- strictly comply with the "traditional" real-time task model (see Section 3)
- can effectively use the new policy.
+ algorithm selects the task with the earliest scheduling deadline as the one
+ to be executed next. Thanks to this feature, tasks that do not strictly comply
+ with the "traditional" real-time task model (see Section 3) can effectively
+ use the new policy.
 
  In more details, the CBS algorithm assigns scheduling deadlines to
  tasks in the following way:
@@ -64,45 +64,45 @@ CONTENTS
     "deadline", and "period" parameters;
 
   - The state of the task is described by a "scheduling deadline", and
-    a "current runtime". These two parameters are initially set to 0;
+    a "remaining runtime". These two parameters are initially set to 0;
 
   - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
     the scheduler checks if
 
-                    current runtime                runtime
-         ---------------------------------- > ----------------
-         scheduling deadline - current time         period
+                 remaining runtime                  runtime
+        ----------------------------------    >    ---------
+        scheduling deadline - current time           period
 
     then, if the scheduling deadline is smaller than the current time, or
     this condition is verified, the scheduling deadline and the
-    current budget are re-initialised as
+    remaining runtime are re-initialised as
 
          scheduling deadline = current time + deadline
-         current runtime = runtime
+         remaining runtime = runtime
 
-    otherwise, the scheduling deadline and the current runtime are
+    otherwise, the scheduling deadline and the remaining runtime are
     left unchanged;
 
   - When a SCHED_DEADLINE task executes for an amount of time t, its
-    current runtime is decreased as
+    remaining runtime is decreased as
 
-         current runtime = current runtime - t
+         remaining runtime = remaining runtime - t
 
     (technically, the runtime is decreased at every tick, or when the
     task is descheduled / preempted);
 
-  - When the current runtime becomes less or equal than 0, the task is
+  - When the remaining runtime becomes less or equal than 0, the task is
     said to be "throttled" (also known as "depleted" in real-time literature)
     and cannot be scheduled until its scheduling deadline. The "replenishment
     time" for this task (see next item) is set to be equal to the current
     value of the scheduling deadline;
 
   - When the current time is equal to the replenishment time of a
-    throttled task, the scheduling deadline and the current runtime are
+    throttled task, the scheduling deadline and the remaining runtime are
     updated as
 
          scheduling deadline = scheduling deadline + period
-         current runtime = current runtime + runtime
+         remaining runtime = remaining runtime + runtime
 
 
 3. Scheduling Real-Time Tasks
@@ -147,6 +147,8 @@ CONTENTS
  and the absolute deadlines (d_j) coincide, so a proper admission control
  allows to respect the jobs' absolute deadlines for this task (this is what is
  called "hard schedulability property" and is an extension of Lemma 1 of [2]).
+ Notice that if runtime > deadline the admission control will surely reject
+ this task, as it is not possible to respect its temporal constraints.
 
  References:
   1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
@@ -156,7 +158,7 @@ CONTENTS
       Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
       Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
   3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
-      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
+      Technical Report. http://disi.unitn.it/~abeni/tr-98-01.pdf
 
 4. Bandwidth management
 =======================
