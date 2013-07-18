Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab3GRTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:51:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41738 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514Ab3GRTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 74/76] perf header: Remove attr_offset from perf_header
Date: Thu, 18 Jul 2013 16:50:01 -0300
Message-Id: <1374177003-3706-75-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing attr_offset from perf_header as it's possible to use it as a
local variable.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 5 +++--
 tools/perf/util/header.h | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 035efe7..dcba56a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2272,6 +2272,7 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
 	struct perf_evsel *evsel;
+	u64 attr_offset;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
@@ -2285,7 +2286,7 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->attr_offset = lseek(fd, 0, SEEK_CUR);
+	attr_offset = lseek(fd, 0, SEEK_CUR);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
@@ -2315,7 +2316,7 @@ int perf_session__write_header(struct perf_session *session,
 		.size	   = sizeof(f_header),
 		.attr_size = sizeof(f_attr),
 		.attrs = {
-			.offset = header->attr_offset,
+			.offset = attr_offset,
 			.size   = evlist->nr_entries * sizeof(f_attr),
 		},
 		.data = {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0bacb2d..6fa80f9 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -86,7 +86,6 @@ struct perf_session_env {
 
 struct perf_header {
 	bool			needs_swap;
-	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
-- 
1.8.1.4

