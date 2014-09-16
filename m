Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaIPK7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:59:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaIPK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:34 -0400
Date: Tue, 16 Sep 2014 03:57:29 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-f5801933ce595ba6eb77d170ab0dfbcd5c894e11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        henrik@austad.us, torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        henrik@austad.us, torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1410256636-26171-5-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-5-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Documentation/scheduler/sched-deadline.txt:
  Add tests suite appendix
Git-Commit-ID: f5801933ce595ba6eb77d170ab0dfbcd5c894e11
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

Commit-ID:  f5801933ce595ba6eb77d170ab0dfbcd5c894e11
Gitweb:     http://git.kernel.org/tip/f5801933ce595ba6eb77d170ab0dfbcd5c894e11
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Tue, 9 Sep 2014 10:57:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:23:02 +0200

Documentation/scheduler/sched-deadline.txt: Add tests suite appendix

Add an appendix briefly describing tools that can be used to
test SCHED_DEADLINE (and the scheduler in general). Links to
where source code of the tools is hosted are also provided.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reviewed-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410256636-26171-5-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-deadline.txt | 52 ++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index 0ce5e2c..b4aad31 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -15,6 +15,7 @@ CONTENTS
  5. Tasks CPU affinity
    5.1 SCHED_DEADLINE and cpusets HOWTO
  6. Future plans
+ A. Test suite
 
 
 0. WARNING
@@ -345,3 +346,54 @@ CONTENTS
  throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
  the preliminary phases of the merge and we really seek feedback that would
  help us decide on the direction it should take.
+
+Appendix A. Test suite
+======================
+
+ The SCHED_DEADLINE policy can be easily tested using two applications that
+ are part of a wider Linux Scheduler validation suite. The suite is
+ available as a GitHub repository: https://github.com/scheduler-tools.
+
+ The first testing application is called rt-app and can be used to
+ start multiple threads with specific parameters. rt-app supports
+ SCHED_{OTHER,FIFO,RR,DEADLINE} scheduling policies and their related
+ parameters (e.g., niceness, priority, runtime/deadline/period). rt-app
+ is a valuable tool, as it can be used to synthetically recreate certain
+ workloads (maybe mimicking real use-cases) and evaluate how the scheduler
+ behaves under such workloads. In this way, results are easily reproducible.
+ rt-app is available at: https://github.com/scheduler-tools/rt-app.
+
+ Thread parameters can be specified from the command line, with something like
+ this:
+
+  # rt-app -t 100000:10000:d -t 150000:20000:f:10 -D5
+
+ The above creates 2 threads. The first one, scheduled by SCHED_DEADLINE,
+ executes for 10ms every 100ms. The second one, scheduled at SCHED_FIFO
+ priority 10, executes for 20ms every 150ms. The test will run for a total
+ of 5 seconds.
+
+ More interestingly, configurations can be described with a json file that
+ can be passed as input to rt-app with something like this:
+
+  # rt-app my_config.json
+
+ The parameters that can be specified with the second method are a superset
+ of the command line options. Please refer to rt-app documentation for more
+ details (<rt-app-sources>/doc/*.json).
+
+ The second testing application is a modification of schedtool, called
+ schedtool-dl, which can be used to setup SCHED_DEADLINE parameters for a
+ certain pid/application. schedtool-dl is available at:
+ https://github.com/scheduler-tools/schedtool-dl.git.
+
+ The usage is straightforward:
+
+  # schedtool -E -t 10000000:100000000 -e ./my_cpuhog_app
+
+ With this, my_cpuhog_app is put to run inside a SCHED_DEADLINE reservation
+ of 10ms every 100ms (note that parameters are expressed in microseconds).
+ You can also use schedtool to create a reservation for an already running
+ application, given that you know its pid:
+
+  # schedtool -E -t 10000000:100000000 my_app_pid
