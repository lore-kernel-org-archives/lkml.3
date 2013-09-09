Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3IICVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:21:05 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25571 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3IICTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:32 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 2/7] perf lock: return proper code in report_lock_*_event
Date: Sun,  8 Sep 2013 19:19:14 -0700
Message-Id: <1378693159-8747-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The report_lock_*_event() functions return -1 when lock_stat_findnew(),
thread_stat_findnew() or get_seq() return NULL. These functions only return
this value when failing to allocate memory, this return -ENOMEM instead.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/builtin-lock.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 148f7e2..d318862 100644
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
1.7.11.7

