Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbbAPVXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:23:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:54214 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbbAPVXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:23:14 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf tools: Elide strlcpy warning with uclibc
Date: Fri, 16 Jan 2015 18:22:38 -0300
Message-Id: <1421443362-10709-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

   ----------------->8------------------
  CC       bench/sched-pipe.o
In file included from builtin-annotate.c:13:0:
util/cache.h:76:15: warning: redundant redeclaration of 'strlcpy'
[-Wredundant-decls]
 extern size_t strlcpy(char *dest, const char *src, size_t size);
               ^
In file included from util/util.h:55:0,
                 from builtin.h:4,
                 from builtin-annotate.c:8:
~/vineetg/arc/gnu/INSTALL_1412-arc-2014.12-rc1/arc-snps-linux-uclibc/sysroot/usr/include/string.h:396:15:
note: previous declaration of 'strlcpy' was here
 extern size_t strlcpy(char *__restrict dst, const char *__restrict src,
   ----------------->8------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421156604-30603-3-git-send-email-vgupta@synopsys.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cache.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 5cf9e1b5989d..d04d770d90f6 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -71,7 +71,9 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
+#ifndef __UCLIBC__
 /* Matches the libc/libbsd function attribute so we declare this unconditionally: */
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#endif
 
 #endif /* __PERF_CACHE_H */
-- 
1.9.3

