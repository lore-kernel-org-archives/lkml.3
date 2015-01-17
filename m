Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbbAQKMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:12:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbbAQKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:12:39 -0500
Date: Sat, 17 Jan 2015 02:12:07 -0800
From: tip-bot for Vineet Gupta <tipbot@zytor.com>
Message-ID: <tip-a83d869f300bf91df07443b5272db7a5a8eb18b7@git.kernel.org>
Cc: tglx@linutronix.de, Vineet.Gupta1@synopsys.com, mingo@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, acme@redhat.com,
        Alexey.Brodkin@synopsys.com, hpa@zytor.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, vgupta@synopsys.com
Reply-To: jolsa@kernel.org, mingo@kernel.org, Vineet.Gupta1@synopsys.com,
        Alexey.Brodkin@synopsys.com, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, vgupta@synopsys.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, hpa@zytor.com
In-Reply-To: <1421156604-30603-3-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-3-git-send-email-vgupta@synopsys.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Elide strlcpy warning with uclibc
Git-Commit-ID: a83d869f300bf91df07443b5272db7a5a8eb18b7
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

Commit-ID:  a83d869f300bf91df07443b5272db7a5a8eb18b7
Gitweb:     http://git.kernel.org/tip/a83d869f300bf91df07443b5272db7a5a8eb18b7
Author:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
AuthorDate: Tue, 13 Jan 2015 19:13:21 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:29 -0300

perf tools: Elide strlcpy warning with uclibc

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
index 5cf9e1b..d04d770 100644
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
