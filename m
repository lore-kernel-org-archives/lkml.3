Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab3JOFbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:31:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3JOFbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:16 -0400
Date: Mon, 14 Oct 2013 22:31:00 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-2969b12993ca7a8b9692048431e075a67815002d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380395584-9025-6-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf intlist: Add priv member
Git-Commit-ID: 2969b12993ca7a8b9692048431e075a67815002d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2969b12993ca7a8b9692048431e075a67815002d
Gitweb:     http://git.kernel.org/tip/2969b12993ca7a8b9692048431e075a67815002d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 13:13:02 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:55 -0300

perf intlist: Add priv member

Allows commands to leverage intlist infrastructure for opaque
structures.

For example an upcoming perf-trace change will use this as a means of
tracking syscalls statistics by task.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intlist.c | 1 +
 tools/perf/util/intlist.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 11a8d86..826d7b3 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -20,6 +20,7 @@ static struct rb_node *intlist__node_new(struct rblist *rblist __maybe_unused,
 
 	if (node != NULL) {
 		node->i = i;
+		node->priv = NULL;
 		rc = &node->rb_node;
 	}
 
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 62351da..0eb00ac 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -9,6 +9,7 @@
 struct int_node {
 	struct rb_node rb_node;
 	int i;
+	void *priv;
 };
 
 struct intlist {
