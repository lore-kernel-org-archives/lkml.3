Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaIXQ2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:28:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:39328 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753344AbaIXQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:28:00 -0400
Message-Id: <20140924162759.829793859@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 24 Sep 2014 12:27:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 3/3] ftracetest: Add kprobe basic testcases
References: <20140924162719.481050866@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftracetest-Add-kprobe-basic-testcases.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add basic testcases for kprobe dynamic events.
This also shows that the ftracetest accepts sub-directory
for new testcases.

Link: http://lkml.kernel.org/p/20140922234254.23415.46964.stgit@kbuild-f20.novalocal

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../selftests/ftrace/test.d/kprobe/add_and_remove.tc       | 11 +++++++++++
 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc | 14 ++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
new file mode 100644
index 000000000000..5ddfb476eceb
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
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
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
new file mode 100644
index 000000000000..588fde97e93f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
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
-- 
2.0.1


