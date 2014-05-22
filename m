Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaEVV5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:57:48 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44342 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaEVV5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:57:46 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: session.c:  Cleaning up inconsistent NULL checks
Date: Thu, 22 May 2014 23:58:36 +0200
Message-Id: <1400795916-12613-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up inconsistent NULL checks.
There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 55960f2..8defd80 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1625,13 +1625,15 @@ out_delete_map:
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 				bool full)
 {
-	int fd = perf_data_file__fd(session->file);
+	int fd;
 	struct stat st;
 	int ret;
 
 	if (session == NULL || fp == NULL)
 		return;
 
+	fd = perf_data_file__fd(session->file);
+
 	ret = fstat(fd, &st);
 	if (ret == -1)
 		return;
-- 
1.7.10.4

