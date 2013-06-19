Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab3FSBC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:02:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60111 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:32 -0400
X-AuditID: 9c93016f-b7b6cae000007078-e1-51c10324e145
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/3] perf tools: include termios.h explicitly
Date: Wed, 19 Jun 2013 10:02:30 +0900
Message-Id: <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building perf for android is failed, because it can't find definition of
struct winsize. This definition is in termios.h, so I add this header
to util.h to solve the problem. It is missed by commit '2c803e52' which
moves get_term_dimensions() from builtin-top.c to util.c, but, missed to
move termios.h header.

Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a45710b..f2c6483 100644
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
1.7.9.5

