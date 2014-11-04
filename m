Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaKDPbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:31:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:62276 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754432AbaKDPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:30:44 -0500
Message-Id: <20141104153028.465517119@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:28:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2 v3] ftracetest: Add functions file that holds helper functions
References: <20141104152845.521858531@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftracetest-Add-functions-file-that-holds-helper-func.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Created the file tools/testing/ftrace/test.d/functions that will
hold helper functions.

Current helper functions include:

 Add clear_trace() helper to reset the trace file

   Used as a descriptive name to show that "echo > trace" is clearing
   the trace file.

 Add disable/enable_tracing() helper calls

   Add calls that disable and enable tracing respectively by echoing
   0 or 1 into tracing_on.

 Add helper reset_tracer() function

    Add a helper function reset_tracer() that will clear the current_tracer
    (echo nop > current_tracer).

Link: http://lkml.kernel.org/r/20141103212737.696365174@goodmis.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest       |  3 +++
 tools/testing/selftests/ftrace/test.d/functions | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/functions

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index f15c0da07aca..c6381a9faf83 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -235,6 +235,9 @@ run_test() { # testfile
   fi
 }
 
+# load in the helper functions
+. $TEST_DIR/functions
+
 # Main loop
 for t in $TEST_CASES; do
   run_test $t
diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
new file mode 100644
index 000000000000..5d8cd06d920f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -0,0 +1,16 @@
+
+clear_trace() { # reset trace output
+    echo > trace
+}
+
+disable_tracing() { # stop trace recording
+    echo 0 > tracing_on
+}
+
+enable_tracing() { # start trace recording
+    echo 1 > tracing_on
+}
+
+reset_tracer() { # reset the current tracer
+    echo nop > current_tracer
+}
-- 
2.1.1


