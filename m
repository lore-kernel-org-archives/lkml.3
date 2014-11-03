Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaKCV26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:28:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754110AbaKCV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:28:45 -0500
Message-Id: <20141103212841.684711364@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 03 Nov 2014 16:27:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 1/4 v2] ftracetest: Add clear_trace() helper to reset the trace file
References: <20141103212737.696365174@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftracetest-Add-clear_trace-helper-to-reset-the-trace.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Created the file tools/testing/ftrace/test.d/functions that will
hold helper functions.

First function added was clear_trace() that is descriptive in its
name to show that "echo > trace" is clearing the trace file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest       | 3 +++
 tools/testing/selftests/ftrace/test.d/functions | 4 ++++
 2 files changed, 7 insertions(+)
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
index 000000000000..1aa9f2e9c40b
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -0,0 +1,4 @@
+
+clear_trace() { # reset trace output
+    echo > trace
+}
-- 
2.1.1


