Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaJHSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:06:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:57050 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504AbaJHSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:05:19 -0400
Message-Id: <20141008180517.956366561@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 14:03:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/5] ftracetest: Add ftrace basic testcases
References: <20141008180341.252728944@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftracetest-Add-ftrace-basic-testcases.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add ftrace basic testcases. This just checks ftrace debugfs
interface works as it is designed.

Link: http://lkml.kernel.org/p/20140922234252.23415.62897.stgit@kbuild-f20.novalocal

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/test.d/00basic/basic1.tc | 3 +++
 tools/testing/selftests/ftrace/test.d/00basic/basic2.tc | 6 ++++++
 tools/testing/selftests/ftrace/test.d/00basic/basic3.tc | 8 ++++++++
 3 files changed, 17 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic3.tc

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic1.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
new file mode 100644
index 000000000000..9980ff14ae44
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: Basic trace file check
+test -f README -a -f trace -a -f tracing_on -a -f trace_pipe
diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
new file mode 100644
index 000000000000..b04f30df0db3
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
@@ -0,0 +1,6 @@
+#!/bin/sh
+# description: Basic test for tracers
+for t in `cat available_tracers`; do
+  echo $t > current_tracer || exit 1
+done
+echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
new file mode 100644
index 000000000000..0c1a3a207636
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
@@ -0,0 +1,8 @@
+#!/bin/sh
+# description: Basic trace clock test
+[ -f trace_clock ] || exit 1
+for c in `cat trace_clock | tr  -d \[\]`; do
+  echo $c > trace_clock || exit 1
+  grep '\['$c'\]' trace_clock || exit 1
+done
+echo local > trace_clock
-- 
2.0.1


