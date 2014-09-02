Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaIBLHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:07:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59848 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaIBLHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:07:02 -0400
Subject: [RFC PATCH v3 3/4] ftracetest: Add kprobe basic testcases
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:06:52 +0000
Message-ID: <20140902110652.3207.15114.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic testcases for kprobe dynamic events.
This also shows that the ftracetest accepts sub-directory
for new testcases.

Changes in v2:
  - Change shell to sh instead of bash.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   11 +++++++++++
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   14 ++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/busy_check.tc

diff --git a/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
new file mode 100644
index 0000000..5ddfb47
--- /dev/null
+++ b/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# description: Kprobe dynamic event - adding and removing
+
+[ -f kprobe_events ] || exit 1
+
+echo 0 > events/enable || exit 1
+echo > kprobe_events || exit 1
+echo p:myevent do_fork > kprobe_events || exit 1
+grep myevent kprobe_events || exit 1
+[ -d events/kprobes/myevent ] || exit 1
+echo > kprobe_events
diff --git a/tools/testing/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/ftrace/test.d/kprobe/busy_check.tc
new file mode 100644
index 0000000..588fde97
--- /dev/null
+++ b/tools/testing/ftrace/test.d/kprobe/busy_check.tc
@@ -0,0 +1,14 @@
+#!/bin/sh
+# description: Kprobe dynamic event - busy event check
+
+[ -f kprobe_events ] || exit 1
+
+echo 0 > events/enable || exit 1
+echo > kprobe_events || exit 1
+echo p:myevent do_fork > kprobe_events || exit 1
+[ -d events/kprobes/myevent ] || exit 1
+echo 1 > events/kprobes/myevent/enable || exit 1
+echo > kprobe_events && exit 1 # this must fail
+echo 0 > events/kprobes/myevent/enable || exit 1
+echo > kprobe_events # this must succeed
+


