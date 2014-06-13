Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaFMG1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:27:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaFMG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:27:16 -0400
Date: Thu, 12 Jun 2014 23:26:59 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-822c45db6398a69879b0539f0819de02b813493c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-12-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-12-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Allow reuse of test_file function
Git-Commit-ID: 822c45db6398a69879b0539f0819de02b813493c
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

Commit-ID:  822c45db6398a69879b0539f0819de02b813493c
Gitweb:     http://git.kernel.org/tip/822c45db6398a69879b0539f0819de02b813493c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 4 May 2014 13:51:46 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:22 +0200

perf tests: Allow reuse of test_file function

Making the test_file function to be reusable for
new tests coming in following patches.

Also changing the template name of temp files to
"/tmp/perf-test-XXXXXX" to easily identify & blame.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-12-git-send-email-jolsa@kernel.org
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
