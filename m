Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaHECqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:46:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42724 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaHECqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:46:08 -0400
Subject: [RFC PATCH 2/3] ftracetest: Add ftrace basic testcases
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 02:45:58 +0000
Message-ID: <20140805024558.23693.27335.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace basic testcases. This just checks ftrace debugfs
interface works as it is designed.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/ftrace/test.d/basic1.tc |    3 +++
 tools/testing/ftrace/test.d/basic2.tc |    6 ++++++
 tools/testing/ftrace/test.d/basic3.tc |    8 ++++++++
 3 files changed, 17 insertions(+)
 create mode 100644 tools/testing/ftrace/test.d/basic1.tc
 create mode 100644 tools/testing/ftrace/test.d/basic2.tc
 create mode 100644 tools/testing/ftrace/test.d/basic3.tc

diff --git a/tools/testing/ftrace/test.d/basic1.tc b/tools/testing/ftrace/test.d/basic1.tc
new file mode 100644
index 0000000..275bd71
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic1.tc
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: Basic trace file check
+test -f README -a -f trace -a -f tracing_on -a -f trace_pipe
diff --git a/tools/testing/ftrace/test.d/basic2.tc b/tools/testing/ftrace/test.d/basic2.tc
new file mode 100644
index 0000000..5849922
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic2.tc
@@ -0,0 +1,6 @@
+#!/bin/bash
+# description: Basic test for tracers
+for t in `cat available_tracers`; do
+  echo $t > current_tracer || exit 1
+done
+echo nop > current_tracer
diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
new file mode 100644
index 0000000..0b9cb2c
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic3.tc
@@ -0,0 +1,8 @@
+#!/bin/bash
+# description: Basic trace clock test
+[ -f trace_clock ] || exit 1
+for c in `cat trace_clock | tr  -d \[\]`; do
+  echo $c > trace_clock || exit 1
+  grep '\['$c'\]' trace_clock || exit 1
+done
+echo local > trace_clock


