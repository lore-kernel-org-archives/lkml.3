Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaANQlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaANQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:59 -0500
Date: Tue, 14 Jan 2014 08:40:35 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-835d44b9041e578e3e553a57dfffc7003605c93b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1389276059-8829-3-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools include: Define likely/unlikely in linux/
 compiler.h
Git-Commit-ID: 835d44b9041e578e3e553a57dfffc7003605c93b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:40:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  835d44b9041e578e3e553a57dfffc7003605c93b
Gitweb:     http://git.kernel.org/tip/835d44b9041e578e3e553a57dfffc7003605c93b
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 9 Jan 2014 23:00:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:26 -0300

tools include: Define likely/unlikely in linux/compiler.h

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-3-git-send-email-namhyung@kernel.org
[ Added the new header to tools/perf/MANIFEST ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/compiler.h | 8 ++++++++
 tools/perf/MANIFEST            | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 0135ccf..fbc6665 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -27,4 +27,12 @@
 # define __weak			__attribute__((weak))
 #endif
 
+#ifndef likely
+# define likely(x)		__builtin_expect(!!(x), 1)
+#endif
+
+#ifndef unlikely
+# define unlikely(x)		__builtin_expect(!!(x), 0)
+#endif
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 3170a7f..285f28f 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,6 +4,7 @@ tools/lib/traceevent
 tools/lib/lk
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/include/linux/compiler.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
