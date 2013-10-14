Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3JNUan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 080/161] perf lock: Return proper code in report_lock_*_event
Date: Mon, 14 Oct 2013 17:01:09 -0300
Message-Id: <1381780950-25642-81-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The report_lock_*_event() functions return -1 when lock_stat_findnew(),
thread_stat_findnew() or get_seq() return NULL. These functions only
return this value when failing to allocate memory, this return -ENOMEM
instead.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-3-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 148f7e28ade7..d3188629cbaf 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -400,17 +400,17 @@ static int report_lock_acquire_event(struct perf_evsel *evsel,
 
 	ls = lock_stat_findnew(addr, name);
 	if (!ls)
-		return -1;
+		return -ENOMEM;
 	if (ls->discard)
 		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
 	if (!ts)
-		return -1;
+		return -ENOMEM;
 
 	seq = get_seq(ts, addr);
 	if (!seq)
-		return -1;
+		return -ENOMEM;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
@@ -472,17 +472,17 @@ static int report_lock_acquired_event(struct perf_evsel *evsel,
 
 	ls = lock_stat_findnew(addr, name);
 	if (!ls)
-		return -1;
+		return -ENOMEM;
 	if (ls->discard)
 		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
 	if (!ts)
-		return -1;
+		return -ENOMEM;
 
 	seq = get_seq(ts, addr);
 	if (!seq)
-		return -1;
+		return -ENOMEM;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
@@ -533,17 +533,17 @@ static int report_lock_contended_event(struct perf_evsel *evsel,
 
 	ls = lock_stat_findnew(addr, name);
 	if (!ls)
-		return -1;
+		return -ENOMEM;
 	if (ls->discard)
 		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
 	if (!ts)
-		return -1;
+		return -ENOMEM;
 
 	seq = get_seq(ts, addr);
 	if (!seq)
-		return -1;
+		return -ENOMEM;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
@@ -587,17 +587,17 @@ static int report_lock_release_event(struct perf_evsel *evsel,
 
 	ls = lock_stat_findnew(addr, name);
 	if (!ls)
-		return -1;
+		return -ENOMEM;
 	if (ls->discard)
 		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
 	if (!ts)
-		return -1;
+		return -ENOMEM;
 
 	seq = get_seq(ts, addr);
 	if (!seq)
-		return -1;
+		return -ENOMEM;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
-- 
1.8.1.4

