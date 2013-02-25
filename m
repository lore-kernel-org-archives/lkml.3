Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab3BYJx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046Ab3BYJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/5] perf tests: Make attr script verbose friendly
Date: Mon, 25 Feb 2013 10:52:49 +0100
Message-Id: <1361785972-7431-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the attr test script runner to pass proper
verbose option. Also making single '-v' be more
reader friendly and display just the test name.

Making the current output to be display for '-vv'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 tools/perf/tests/attr.c  | 9 +++++++--
 tools/perf/tests/attr.py | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index bdcceb8..038de3e 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -147,10 +147,15 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 
 static int run_dir(const char *d, const char *perf)
 {
+	char v[] = "-vvvvv";
+	int vcnt = min(verbose, (int) sizeof(v) - 1);
 	char cmd[3*PATH_MAX];
 
-	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %s",
-		 d, d, perf, verbose ? "-v" : "");
+	if (verbose)
+		vcnt++;
+
+	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %.*s",
+		 d, d, perf, vcnt, v);
 
 	return system(cmd);
 }
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 2f629ca..e0ea513 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -121,7 +121,7 @@ class Test(object):
         parser = ConfigParser.SafeConfigParser()
         parser.read(path)
 
-        log.debug("running '%s'" % path)
+        log.warning("running '%s'" % path)
 
         self.path     = path
         self.test_dir = options.test_dir
@@ -172,7 +172,7 @@ class Test(object):
               self.perf, self.command, tempdir, self.args)
         ret = os.WEXITSTATUS(os.system(cmd))
 
-        log.warning("  running '%s' ret %d " % (cmd, ret))
+        log.info("  '%s' ret %d " % (cmd, ret))
 
         if ret != int(self.ret):
             raise Unsup(self)
-- 
1.7.11.7

