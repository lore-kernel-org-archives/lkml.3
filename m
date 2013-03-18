Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3CRQfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:35:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49388
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/54] perf tests: Make attr script verbose friendly
Date: Mon, 18 Mar 2013 13:24:51 -0300
Message-Id: <1363623939-10748-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Making the attr test script runner to pass proper verbose option. Also
making single '-v' be more reader friendly and display just the test
name.

Making the current output to be display for '-vv'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361785972-7431-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c  |    9 +++++++--
 tools/perf/tests/attr.py |    4 ++--
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
1.7.1

