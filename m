Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3JNUqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:46:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab3JNUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 030/161] tools/perf: Clean up util/include/linux/compiler.h
Date: Mon, 14 Oct 2013 17:00:19 -0300
Message-Id: <1381780950-25642-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Use the standard CPP style we use in the kernel:

 #ifndef foo
 # define foo bar
 #endif

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-iqyVrrHqpn0eiwenvgwrh8lf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/include/linux/compiler.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 96b919dae11c..bef4d3ddc493 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -2,20 +2,25 @@
 #define _PERF_LINUX_COMPILER_H_
 
 #ifndef __always_inline
-#define __always_inline	inline
+# define __always_inline	inline __attribute__((always_inline))
 #endif
+
 #define __user
+
 #ifndef __attribute_const__
-#define __attribute_const__
+# define __attribute_const__
 #endif
 
 #ifndef __maybe_unused
-#define __maybe_unused		__attribute__((unused))
+# define __maybe_unused		__attribute__((unused))
+#endif
+
+#ifndef __packed
+# define __packed		__attribute__((__packed__))
 #endif
-#define __packed	__attribute__((__packed__))
 
 #ifndef __force
-#define __force
+# define __force
 #endif
 
 #endif
-- 
1.8.1.4

