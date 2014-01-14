Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaANQky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:40:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaANQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:48 -0500
Date: Tue, 14 Jan 2014 08:40:25 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8a625c1f61f3dd5e4ea4b5b642650416aa101ce5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1389276059-8829-2-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools include: Move perf's linux/
 compiler.h to a generic place
Git-Commit-ID: 8a625c1f61f3dd5e4ea4b5b642650416aa101ce5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:40:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a625c1f61f3dd5e4ea4b5b642650416aa101ce5
Gitweb:     http://git.kernel.org/tip/8a625c1f61f3dd5e4ea4b5b642650416aa101ce5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 9 Jan 2014 23:00:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:25 -0300

tools include: Move perf's linux/compiler.h to a generic place

So that it can be shared with others like libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/{perf/util => }/include/linux/compiler.h | 6 +++---
 tools/perf/Makefile.perf                       | 2 +-
 tools/perf/config/Makefile                     | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/include/linux/compiler.h
similarity index 80%
rename from tools/perf/util/include/linux/compiler.h
rename to tools/include/linux/compiler.h
index b003ad7..0135ccf 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_LINUX_COMPILER_H_
-#define _PERF_LINUX_COMPILER_H_
+#ifndef _TOOLS_LINUX_COMPILER_H_
+#define _TOOLS_LINUX_COMPILER_H_
 
 #ifndef __always_inline
 # define __always_inline	inline __attribute__((always_inline))
@@ -27,4 +27,4 @@
 # define __weak			__attribute__((weak))
 #endif
 
-#endif
+#endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3638b0b..6be0676 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -211,7 +211,7 @@ LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
-LIB_H += util/include/linux/compiler.h
+LIB_H += ../include/linux/compiler.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d15b43..01dd43d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -232,6 +232,7 @@ endif
 
 CFLAGS += -I$(src-perf)/util/include
 CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/tools/include/
 CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
 CFLAGS += -I$(srctree)/arch/$(ARCH)/include
 CFLAGS += -I$(srctree)/include/uapi
