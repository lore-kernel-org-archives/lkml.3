Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3JOFYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3JOFYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:24:50 -0400
Date: Mon, 14 Oct 2013 22:24:02 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-02ad0702e54f9b82b697718e7e8662eb3f2266ee@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1378693159-8747-2-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-2-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Remove dead code
Git-Commit-ID: 02ad0702e54f9b82b697718e7e8662eb3f2266ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:24:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02ad0702e54f9b82b697718e7e8662eb3f2266ee
Gitweb:     http://git.kernel.org/tip/02ad0702e54f9b82b697718e7e8662eb3f2266ee
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sun, 8 Sep 2013 19:19:13 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:23:21 -0300

perf lock: Remove dead code

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
