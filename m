Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298Ab3GSHoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:44:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964929Ab3GSHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:44:16 -0400
Date: Fri, 19 Jul 2013 00:43:39 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-ba58041a8f0f0437c6c33414aa0d3fcf62ba90a5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370643734-9579-3-git-send-email-dsahern@gmail.com>
References: <1370643734-9579-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add methods for setting/
 retrieving priv element of thread struct
Git-Commit-ID: ba58041a8f0f0437c6c33414aa0d3fcf62ba90a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:43:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba58041a8f0f0437c6c33414aa0d3fcf62ba90a5
Gitweb:     http://git.kernel.org/tip/ba58041a8f0f0437c6c33414aa0d3fcf62ba90a5
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 7 Jun 2013 16:22:12 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:56 -0300

perf tools: Add methods for setting/retrieving priv element of thread struct

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1370643734-9579-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index eeb7ac6..5e7ba35 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -47,4 +47,14 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
+
+static inline void *thread__priv(struct thread *thread)
+{
+	return thread->priv;
+}
+
+static inline void thread__set_priv(struct thread *thread, void *p)
+{
+	thread->priv = p;
+}
 #endif	/* __PERF_THREAD_H */
