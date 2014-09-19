Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaISFWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaISFWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:22:51 -0400
Date: Thu, 18 Sep 2014 22:22:00 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-k4ocrq1de3fk146oevy346bi@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        maillist-linux@barfooze.de, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, maillist-linux@barfooze.de, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't include sys/poll.h directly
Git-Commit-ID: a8fa496092253a6309d46ecfe75eea4ab1d6fd79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8fa496092253a6309d46ecfe75eea4ab1d6fd79
Gitweb:     http://git.kernel.org/tip/a8fa496092253a6309d46ecfe75eea4ab1d6fd79
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Sep 2014 15:54:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:09 -0300

perf tools: Don't include sys/poll.h directly

Include poll.h instead.

Fixes the following warning in systems with musl's libc:

  /usr/include/sys/poll.h:1:2: warning: #warning redirecting incorrect #include
  <sys/poll.h> to <poll.h> [-Wcpp]

Reported-by: John Spencer <maillist-linux@barfooze.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://thread.gmane.org/gmane.linux.kernel.perf.user/1687/focus=1690
Link: http://lkml.kernel.org/n/tip-k4ocrq1de3fk146oevy346bi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-messaging.c | 2 +-
 tools/perf/builtin-top.c           | 2 +-
 tools/perf/util/util.h             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 52a5659..d7f281c 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -26,7 +26,7 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <sys/time.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <limits.h>
 #include <err.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7da2c46..e13864b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -59,7 +59,7 @@
 
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/prctl.h>
 #include <sys/wait.h>
 #include <sys/uio.h>
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index d6a79b1..6ad2b5e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -64,7 +64,7 @@
 #include <regex.h>
 #include <utime.h>
 #include <sys/wait.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
