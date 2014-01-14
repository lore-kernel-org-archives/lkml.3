Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaANQlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaANQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:05 -0500
Date: Tue, 14 Jan 2014 08:40:46 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-02dfc8d775f0709ab494d4b2cce12c8429ff7530@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1389276059-8829-4-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools include: Move perf'
 s bug.h to a generic place
Git-Commit-ID: 02dfc8d775f0709ab494d4b2cce12c8429ff7530
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:40:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02dfc8d775f0709ab494d4b2cce12c8429ff7530
Gitweb:     http://git.kernel.org/tip/02dfc8d775f0709ab494d4b2cce12c8429ff7530
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 9 Jan 2014 23:00:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:26 -0300

tools include: Move perf's bug.h to a generic place

So that it can be shared with others like libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-4-git-send-email-namhyung@kernel.org
[ Added the new header to tools/perf/MANIFEST ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/{perf/util => }/include/asm/bug.h | 7 ++++---
 tools/perf/MANIFEST                     | 1 +
 tools/perf/Makefile.perf                | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/include/asm/bug.h b/tools/include/asm/bug.h
similarity index 85%
rename from tools/perf/util/include/asm/bug.h
rename to tools/include/asm/bug.h
index 7fcc681..eca78df 100644
--- a/tools/perf/util/include/asm/bug.h
+++ b/tools/include/asm/bug.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_ASM_GENERIC_BUG_H
-#define _PERF_ASM_GENERIC_BUG_H
+#ifndef _TOOLS_ASM_BUG_H
+#define _TOOLS_ASM_BUG_H
 
 #define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
 
@@ -19,4 +19,5 @@
 			__warned = 1;		\
 	unlikely(__ret_warn_once);		\
 })
-#endif
+
+#endif /* _TOOLS_ASM_BUG_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 285f28f..4e53535 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,6 +4,7 @@ tools/lib/traceevent
 tools/lib/lk
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/include/asm/bug.h
 tools/include/linux/compiler.h
 include/linux/const.h
 include/linux/perf_event.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6be0676..87d7726 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -226,7 +226,7 @@ LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
-LIB_H += util/include/asm/bug.h
+LIB_H += ../include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
