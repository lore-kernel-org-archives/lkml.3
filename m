Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab3KNUZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:25:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36275 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3KNUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf top: Add missing newline if the 'uid' is invalid
Date: Thu, 14 Nov 2013 17:25:08 -0300
Message-Id: <1384460715-23198-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Add missing newline if the 'uid' is invalid:

  hubble:~> perf top --stdio -u help
  Error:
  Invalid User: helphubble:~>

Fixed by this patch:

  comet:~/tip/tools/perf> perf top --stdio -u help
  Error:
  Invalid User: help
  comet:~/tip/tools/perf>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131112232609.GA31474@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b8f8e29db332..71e6402729a8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1172,7 +1172,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	status = target__validate(target);
 	if (status) {
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__warning("%s\n", errbuf);
 	}
 
 	status = target__parse_uid(target);
@@ -1180,7 +1180,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		int saved_errno = errno;
 
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__error("%s", errbuf);
+		ui__error("%s\n", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
-- 
1.8.1.4

