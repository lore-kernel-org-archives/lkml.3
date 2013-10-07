Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3JGMEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:04:55 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:40023 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3JGL6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:16 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 29/50] tools/perf: Clean up util/include/linux/compiler.h
Date: Mon,  7 Oct 2013 13:56:22 +0200
Message-Id: <1381147003-2574-30-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 96b919d..bef4d3d 100644
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
1.7.11.7

