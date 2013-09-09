Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3IICVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:21:06 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45932 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3IICTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:32 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 1/7] perf lock: remove dead code
Date: Sun,  8 Sep 2013 19:19:13 -0700
Message-Id: <1378693159-8747-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for break statements after goto jumps.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/builtin-lock.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ee33ba2..148f7e2 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -446,7 +446,6 @@ broken:
 		list_del(&seq->list);
 		free(seq);
 		goto end;
-		break;
 	default:
 		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
@@ -508,8 +507,6 @@ static int report_lock_acquired_event(struct perf_evsel *evsel,
 		list_del(&seq->list);
 		free(seq);
 		goto end;
-		break;
-
 	default:
 		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
@@ -564,7 +561,6 @@ static int report_lock_contended_event(struct perf_evsel *evsel,
 		list_del(&seq->list);
 		free(seq);
 		goto end;
-		break;
 	default:
 		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
@@ -606,7 +602,6 @@ static int report_lock_release_event(struct perf_evsel *evsel,
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
 		goto end;
-		break;
 	case SEQ_STATE_ACQUIRED:
 		break;
 	case SEQ_STATE_READ_ACQUIRED:
@@ -624,7 +619,6 @@ static int report_lock_release_event(struct perf_evsel *evsel,
 		ls->discard = 1;
 		bad_hist[BROKEN_RELEASE]++;
 		goto free_seq;
-		break;
 	default:
 		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
-- 
1.7.11.7

