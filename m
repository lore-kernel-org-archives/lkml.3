Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3GJTYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:24:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3GJTTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/23] perf tools: Include termios.h explicitly
Date: Wed, 10 Jul 2013 16:19:05 -0300
Message-Id: <1373483963-19277-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Building perf for android fails because it can't find the definition of
struct winsize.

This definition is in termios.h, so I add this header to util.h to solve
the problem.

It is missed by commit '2c803e52' which moves get_term_dimensions() from
builtin-top.c to util.c, but missed to move termios.h header.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7a484c9..2732fad 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -72,6 +72,7 @@
 #include "types.h"
 #include <sys/ttydefaults.h>
 #include <lk/debugfs.h>
+#include <termios.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -274,6 +275,5 @@ void dump_stack(void);
 
 extern unsigned int page_size;
 
-struct winsize;
 void get_term_dimensions(struct winsize *ws);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

