Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaIBLG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:06:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39013 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaIBLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:06:55 -0400
Subject: [RFC PATCH v3 2/4] ftracetest: Add ftrace basic testcases
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:06:45 +0000
Message-ID: <20140902110645.3207.87391.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace basic testcases. This just checks ftrace debugfs
interface works as it is designed.

Changes in v2:
  - Change shell to sh instead of bash.

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
index 0000000..9980ff1
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic1.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: Basic trace file check
+test -f README -a -f trace -a -f tracing_on -a -f trace_pipe
diff --git a/tools/testing/ftrace/test.d/basic2.tc b/tools/testing/ftrace/test.d/basic2.tc
new file mode 100644
index 0000000..b04f30d
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic2.tc
@@ -0,0 +1,6 @@
+#!/bin/sh
+# description: Basic test for tracers
+for t in `cat available_tracers`; do
+  echo $t > current_tracer || exit 1
+done
+echo nop > current_tracer
diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
new file mode 100644
index 0000000..0c1a3a2
--- /dev/null
+++ b/tools/testing/ftrace/test.d/basic3.tc
@@ -0,0 +1,8 @@
+#!/bin/sh
+# description: Basic trace clock test
+[ -f trace_clock ] || exit 1
+for c in `cat trace_clock | tr  -d \[\]`; do
+  echo $c > trace_clock || exit 1
+  grep '\['$c'\]' trace_clock || exit 1
+done
+echo local > trace_clock


