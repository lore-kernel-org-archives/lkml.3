Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaIQVZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:58178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaIQVZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:32 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/20] perf tools: Don't include sys/poll.h directly
Date: Wed, 17 Sep 2014 18:24:17 -0300
Message-Id: <1410989063-14207-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 52a56599a543..d7f281c2828d 100644
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
index 7da2c46ea38f..e13864be2acb 100644
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
index d6a79b1fb28c..6ad2b5e3d5bb 100644
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
-- 
1.9.3

