Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab3K1Ll7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab3K1Ldz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:33:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/29] perf tools: Include test-stackprotector-all.c in test-all
Date: Thu, 28 Nov 2013 12:33:01 +0100
Message-Id: <1385638408-23519-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're missing test-stackprotector-all.c in test-all
check, adding it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/feature-checks/test-all.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 59e7a70..9b8a544 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -85,6 +85,10 @@
 # include "test-timerfd.c"
 #undef main
 
+#define main main_test_stackprotector_all
+# include "test-stackprotector-all.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -106,6 +110,7 @@ int main(int argc, char *argv[])
 	main_test_backtrace();
 	main_test_libnuma();
 	main_test_timerfd();
+	main_test_stackprotector_all();
 
 	return 0;
 }
-- 
1.8.3.1

