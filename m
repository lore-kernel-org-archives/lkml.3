Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3A3OvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57840 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3A3OrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/21] perf tools: Use memdup in map__clone
Date: Wed, 30 Jan 2013 11:46:45 -0300
Message-Id: <1359557222-17547-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We have memdup() exactly for that, remove open coded dup.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tnsoexrgv6u9l125srq2c7su@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b6b1636..6fcb9de 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -11,6 +11,7 @@
 #include "strlist.h"
 #include "vdso.h"
 #include "build-id.h"
+#include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -213,12 +214,7 @@ struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 
 struct map *map__clone(struct map *map)
 {
-	struct map *clone = malloc(sizeof(*clone));
-
-	if (clone != NULL)
-		memcpy(clone, map, sizeof(*clone));
-
-	return clone;
+	return memdup(map, sizeof(*map));
 }
 
 int map__overlap(struct map *l, struct map *r)
-- 
1.8.1.1.361.gec3ae6e

