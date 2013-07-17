Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab3GQRvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921Ab3GQRvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/23] perf tools: Remove attr_offset from perf_header
Date: Wed, 17 Jul 2013 19:49:43 +0200
Message-Id: <1374083403-14591-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing attr_offset from perf_header as it's possible
to use it as a local variable.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

