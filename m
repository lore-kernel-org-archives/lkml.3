Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3A3Oux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:50:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54423
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab3A3OrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/21] perf kmem: Use memdup()
Date: Wed, 30 Jan 2013 11:46:46 -0300
Message-Id: <1359557222-17547-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of hand coded equivalent.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-42ldngi973f4ssvzlklo8t2k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c746108..46878da 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include <linux/rbtree.h>
+#include <linux/string.h>
 
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
@@ -618,12 +619,11 @@ static int sort_dimension__add(const char *tok, struct list_head *list)
 
 	for (i = 0; i < NUM_AVAIL_SORTS; i++) {
 		if (!strcmp(avail_sorts[i]->name, tok)) {
-			sort = malloc(sizeof(*sort));
+			sort = memdup(avail_sorts[i], sizeof(*avail_sorts[i]));
 			if (!sort) {
-				pr_err("%s: malloc failed\n", __func__);
+				pr_err("%s: memdup failed\n", __func__);
 				return -1;
 			}
-			memcpy(sort, avail_sorts[i], sizeof(*sort));
 			list_add_tail(&sort->list, list);
 			return 0;
 		}
-- 
1.8.1.1.361.gec3ae6e

