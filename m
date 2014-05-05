Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaEERuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:50:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaEERuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:50:13 -0400
Date: Mon, 5 May 2014 10:49:12 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2c83bc08e305e135b954d82596864b7d024fc7fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-8-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-8-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move perf_call_graph_mode enum from perf.h
Git-Commit-ID: 2c83bc08e305e135b954d82596864b7d024fc7fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c83bc08e305e135b954d82596864b7d024fc7fd
Gitweb:     http://git.kernel.org/tip/2c83bc08e305e135b954d82596864b7d024fc7fd
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:46:17 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:48:10 +0200

perf tools: Move perf_call_graph_mode enum from perf.h

Into util/callchain.h header where all callchain related
structures should be.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-8-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h           | 7 -------
 tools/perf/util/callchain.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf8f228..d51a994 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -222,13 +222,6 @@ void pthread__unblock_sigwinch(void);
 
 #include "util/target.h"
 
-enum perf_call_graph_mode {
-	CALLCHAIN_NONE,
-	CALLCHAIN_FP,
-	CALLCHAIN_DWARF,
-	CALLCHAIN_MAX
-};
-
 struct record_opts {
 	struct target target;
 	int	     call_graph;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dda4cf8..bde2b0c 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,6 +7,13 @@
 #include "event.h"
 #include "symbol.h"
 
+enum perf_call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
+};
+
 enum chain_mode {
 	CHAIN_NONE,
 	CHAIN_FLAT,
