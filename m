Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3KDUUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KDUUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:17 -0500
Date: Mon, 4 Nov 2013 12:19:56 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-fedd63d3cdc9004df43b02df5c874b8957992fe8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1381468543-25334-8-git-send-email-namhyung@kernel.org>
References: <1381468543-25334-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Compare hists comm by addresses
Git-Commit-ID: fedd63d3cdc9004df43b02df5c874b8957992fe8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:20:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fedd63d3cdc9004df43b02df5c874b8957992fe8
Gitweb:     http://git.kernel.org/tip/fedd63d3cdc9004df43b02df5c874b8957992fe8
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Sep 2013 17:18:09 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:14:59 -0300

perf tools: Compare hists comm by addresses

Now that comm strings are allocated only once and refcounted to be shared
among threads, these can now be safely compared by addresses. This
should remove most hists collapses on post processing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381468543-25334-8-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 835e8bd..bf91d0e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -80,7 +80,8 @@ struct sort_entry sort_thread = {
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->tid - left->thread->tid;
+	/* Compare the addr that should be unique among comm */
+	return thread__comm_str(right->thread) - thread__comm_str(left->thread);
 }
 
 static int64_t
