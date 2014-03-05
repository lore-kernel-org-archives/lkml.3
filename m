Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaCEOiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaCEOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vinson Lee <vlee@twopensource.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 27/62] perf tools: Remove extraneous newline when parsing hardware cache events
Date: Wed,  5 Mar 2014 14:36:31 +0000
Message-Id: <1394030226-26652-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 42e1fb776087713b5482cd7cf6cac998fbdd6544 upstream.

Noticed while developing a 'perf test' entry to verify that
perf_evsel__name works.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xz6zgh38mp3cjnd2udh38z8f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05dbc8b..d2006bd 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -420,7 +420,7 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	for (i = 0; (i < 2) && (op_result[i]); i++) {
 		char *str = op_result[i];
 
-		snprintf(name + n, MAX_NAME_LEN - n, "-%s\n", str);
+		snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
 
 		if (cache_op == -1) {
 			cache_op = parse_aliases(str, hw_cache_op,
-- 
1.9.0

