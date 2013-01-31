Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3AaKk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:40:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3AaKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:40:27 -0500
Date: Thu, 31 Jan 2013 02:39:37 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-tnsoexrgv6u9l125srq2c7su@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use memdup in map__clone
Git-Commit-ID: 8e16017d497e9bb37c8c3c5ed1edb8d6adeebf3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:39:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e16017d497e9bb37c8c3c5ed1edb8d6adeebf3a
Gitweb:     http://git.kernel.org/tip/8e16017d497e9bb37c8c3c5ed1edb8d6adeebf3a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 22:16:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jan 2013 12:49:28 -0300

perf tools: Use memdup in map__clone

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
