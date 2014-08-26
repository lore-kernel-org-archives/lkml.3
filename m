Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbaHZLPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:15:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34465 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbaHZLPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:15:41 -0400
Subject: [RFC PATCH v2 3/4] ftracetest: Add kprobe basic testcases
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Aug 2014 11:15:32 +0000
Message-ID: <20140826111532.5711.54595.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
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


