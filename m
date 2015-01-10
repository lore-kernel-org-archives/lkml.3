Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbbAJLLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 06:11:37 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:60135 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbbAJLLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 06:11:34 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>
CC: <peterz@infradead.org>, <jolsa@kernel.org>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 2/5] perf tools: [uclibc] Elide strlcpy warning
Date: Sat, 10 Jan 2015 16:40:51 +0530
Message-ID: <1420888254-17504-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.9.1

