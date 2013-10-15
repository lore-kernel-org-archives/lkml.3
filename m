Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3JOFY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3JOFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:24:52 -0400
Date: Mon, 14 Oct 2013 22:24:11 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-b33492ade49a223a666e582d0c63566609e7014b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1378693159-8747-3-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-3-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock:
  Return proper code in report_lock_*_event
Git-Commit-ID: b33492ade49a223a666e582d0c63566609e7014b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:24:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b33492ade49a223a666e582d0c63566609e7014b
Gitweb:     http://git.kernel.org/tip/b33492ade49a223a666e582d0c63566609e7014b
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sun, 8 Sep 2013 19:19:14 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:23:32 -0300

perf lock: Return proper code in report_lock_*_event

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
