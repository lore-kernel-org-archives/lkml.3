Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3IZI61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:58:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50010 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3IZI6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:23 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-ea-5243f7264753
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf tools: Compare hists comm by addresses
Date: Thu, 26 Sep 2013 17:58:09 +0900
Message-Id: <1380185890-25758-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Now that comm strings are allocated only once and refcounted to be shared
among threads, these can now be safely compared by addresses. This
should remove most hists collapses on post processing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 65fe958ce30b..48e6a38132c9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -79,7 +79,8 @@ struct sort_entry sort_thread = {
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->tid - left->thread->tid;
+	/* Compare the addr that should be unique among comm */
+	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);
 }
 
 static int64_t
-- 
1.7.11.7

