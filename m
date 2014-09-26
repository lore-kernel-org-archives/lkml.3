Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198AbaIZUUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:20:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:52692 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaIZUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:10 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pranith Kumar <bobby.prani@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf tools: Use ACCESS_ONCE() instead of volatile cast
Date: Fri, 26 Sep 2014 17:19:41 -0300
Message-Id: <1411762787-26113-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Use ACCESS_ONCE() instead of the cast to volatile and read. This is just
a style change which is reader friendly.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1411484109-10442-1-git-send-email-bobby.prani@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8dd41cad2d59..ffb440462008 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,5 +126,5 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 
 extern volatile int session_done;
 
-#define session_done()	(*(volatile int *)(&session_done))
+#define session_done()	ACCESS_ONCE(session_done)
 #endif /* __PERF_SESSION_H */
-- 
1.9.3

