Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaI0HZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:25:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaI0HZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:25:50 -0400
Date: Sat, 27 Sep 2014 00:25:23 -0700
From: tip-bot for Pranith Kumar <tipbot@zytor.com>
Message-ID: <tip-1da34daf24823f19cfd56c97973334cd95635926@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        bobby.prani@gmail.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, bobby.prani@gmail.com,
        jolsa@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
References: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use ACCESS_ONCE()
  instead of volatile cast
Git-Commit-ID: 1da34daf24823f19cfd56c97973334cd95635926
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

Commit-ID:  1da34daf24823f19cfd56c97973334cd95635926
Gitweb:     http://git.kernel.org/tip/1da34daf24823f19cfd56c97973334cd95635926
Author:     Pranith Kumar <bobby.prani@gmail.com>
AuthorDate: Tue, 23 Sep 2014 10:55:08 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 12:36:03 -0300

perf tools: Use ACCESS_ONCE() instead of volatile cast

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
index 8dd41ca..ffb4404 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,5 +126,5 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 
 extern volatile int session_done;
 
-#define session_done()	(*(volatile int *)(&session_done))
+#define session_done()	ACCESS_ONCE(session_done)
 #endif /* __PERF_SESSION_H */
