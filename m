Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3C1REt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:04:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3C1RC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/36] perf tools: Fix output of symbol_daddr offset
Date: Thu, 28 Mar 2013 14:02:30 -0300
Message-Id: <1364490156-32064-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The symbol addresses in a dso have relative offsets from the start of a
mapping.  So in order to ouput correct offset value from @ip, one of
them should be converted.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1359040242-8269-19-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 32a1ef1..5f52d49 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -202,7 +202,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 		if (map->type == MAP__VARIABLE) {
 			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
 			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
-					ip - sym->start);
+					ip - map->unmap_ip(map, sym->start));
 			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
 				       width - ret, "");
 		} else {
-- 
1.7.1

