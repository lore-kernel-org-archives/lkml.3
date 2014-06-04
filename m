Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaFDOho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaFDOhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:37:43 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/13] perf tests: Allow reuse of test_file function
Date: Wed,  4 Jun 2014 16:37:00 +0200
Message-Id: <1401892622-30848-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the test_file function to be reusable for
new tests coming in following patches.

Also changing the template name of temp files to
"/tmp/perf-test-XXXXXX" to easily identify & blame.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/dso-data.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 3e6cb17..7384381 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -12,11 +12,15 @@
 
 static char *test_file(int size)
 {
-	static char buf_templ[] = "/tmp/test-XXXXXX";
+#define TEMPL "/tmp/perf-test-XXXXXX"
+	static char buf_templ[sizeof(TEMPL)];
 	char *templ = buf_templ;
 	int fd, i;
 	unsigned char *buf;
 
+	strcpy(buf_templ, TEMPL);
+#undef TEMPL
+
 	fd = mkstemp(templ);
 	if (fd < 0) {
 		perror("mkstemp failed");
-- 
1.8.3.1

