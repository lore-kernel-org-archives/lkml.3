Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734AbaH1KAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:00:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56485 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672AbaH1KAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:00:33 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] Documentation/scheduler/sched-deadline.txt: add tests suite appendix
Date: Thu, 28 Aug 2014 11:00:29 +0100
Message-Id: <1409220029-9002-5-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 28 Aug 2014 10:00:29.0128 (UTC) FILETIME=[E5B5A480:01CFC2A6]
X-MC-Unique: 114082811003021401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7SA0kmW017321

Add an appendix briefly describing tools that can be used to test SCHED_DEADLINE
(and the scheduler in general). Links to where source code of the tools is hosted
are also provided.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Henrik Austad <henrik@austad.us>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/scheduler/sched-deadline.txt | 52 ++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index 641395e..2f5b174 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -15,6 +15,7 @@ CONTENTS
  5. Tasks CPU affinity
    5.1 SCHED_DEADLINE and cpusets HOWTO
  6. Future plans
+ A. Test suite
 
 
 0. WARNING
@@ -341,3 +342,54 @@ CONTENTS
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
+ The above creates two threads. The first one, scheduled by SCHED_DEADLINE,
+ executes for 10ms every 100ms and the second one, scheduled at RT priority 10
+ with SCHED_FIFO, executes for 20ms every 150ms. The configuration runs
+ for 5 seconds.
+
+ More interestingly, configurations can be described with a json file that
+ can be passed as input to rt-app with something like this:
+
+  # rt-app my_config.json
+
+ The parameters that can be specified with the second method are a superset
+ of the command line options. Please refer to rt-app documentation for more
+ details.
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
-- 
2.0.4


