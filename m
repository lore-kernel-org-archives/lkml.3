Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaLJEin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:38:43 -0500
Received: from ozlabs.org ([103.22.144.67]:39618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbaLJEim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:38:42 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: rostedt@goodmis.org
Cc: namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftracetest: Replace usleep with sleep 0.000001
Date: Wed, 10 Dec 2014 15:38:27 +1100
Message-Id: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usleep is a Fedoraism, it's not generally available on Debian based
systems AFAICS.

GNU sleep accepts a floating point argument, so use that instead.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/ftrace/test.d/event/event-enable.tc     | 6 +++---
 tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
index 668616d9bb03..c5343add3407 100644
--- a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
+++ b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
@@ -21,7 +21,7 @@ reset_tracer
 do_reset
 
 echo 'sched:sched_switch' > set_event
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep sched_switch | wc -l`
 if [ $count -eq 0 ]; then
@@ -31,7 +31,7 @@ fi
 do_reset
 
 echo 1 > events/sched/sched_switch/enable
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep sched_switch | wc -l`
 if [ $count -eq 0 ]; then
@@ -41,7 +41,7 @@ fi
 do_reset
 
 echo 0 > events/sched/sched_switch/enable
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep sched_switch | wc -l`
 if [ $count -ne 0 ]; then
diff --git a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
index 655c415b6e7f..84a2020d4e7b 100644
--- a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
+++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
@@ -21,7 +21,7 @@ reset_tracer
 do_reset
 
 echo 'sched:*' > set_event
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
@@ -31,7 +31,7 @@ fi
 do_reset
 
 echo 1 > events/sched/enable
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
@@ -41,7 +41,7 @@ fi
 do_reset
 
 echo 0 > events/sched/enable
-usleep 1
+sleep 0.000001
 
 count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -ne 0 ]; then
-- 
1.9.1

