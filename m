Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaHNCV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:21:28 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40611 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaHNCUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:20:42 -0400
X-AuditID: 85900ec0-d312bb9000001514-ae-53ec1cf7e351
Subject: [PATCH 6/8] perf trace: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:20:38 +0000
Message-ID: <20140814022038.3140.31255.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
References: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error message
for thead-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-trace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d080b9c..a9e96ff 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1750,7 +1750,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 signed_print:
 		fprintf(trace->output, ") = %d", ret);
 	} else if (ret < 0 && sc->fmt->errmsg) {
-		char bf[256];
+		char bf[STRERR_BUFSIZE];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
 			   *e = audit_errno_to_name(-ret);
 
@@ -2044,6 +2044,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	int err = -1, i;
 	unsigned long before;
 	const bool forks = argc > 0;
+	char sbuf[STRERR_BUFSIZE];
 
 	trace->live = true;
 
@@ -2105,7 +2106,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
-		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
+		fprintf(trace->output, "Couldn't mmap the events: %s\n",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 

