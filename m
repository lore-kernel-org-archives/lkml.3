Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3JNU0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 079/161] perf lock: Remove dead code
Date: Mon, 14 Oct 2013 17:01:08 -0300
Message-Id: <1381780950-25642-80-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

No need for break statements after goto jumps.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-2-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ee33ba2f05dd..148f7e28ade7 100644
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
1.8.1.4

