Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaIWOzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:55:16 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:43022 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaIWOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:55:11 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENT...)
Subject: [PATCH] perf: Use ACCESS_ONCE() instead of volatile cast
Date: Tue, 23 Sep 2014 10:55:08 -0400
Message-Id: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ACCESS_ONCE() instead of the cast to volatile and read. This is just a style
change which is reader friendly.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 tools/perf/util/session.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8dd41ca..ffb4404 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,5 +126,5 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 
 extern volatile int session_done;
 
-#define session_done()	(*(volatile int *)(&session_done))
+#define session_done()	ACCESS_ONCE(session_done)
 #endif /* __PERF_SESSION_H */
-- 
2.1.0

