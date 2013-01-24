Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3AXUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:09:26 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54077
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899Ab3AXUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 43/74] perf sort: Get rid of unnecessary __maybe_unused
Date: Thu, 24 Jan 2013 17:07:52 -0300
Message-Id: <1359058103-31645-44-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some functions have set __maybe_unused on its arguments that are used
actually.  Remove them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index ce5d404..3c2836e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -197,7 +197,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
-				     unsigned int width __maybe_unused)
+				     unsigned int width)
 {
 	size_t ret = 0;
 
@@ -224,8 +224,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 }
 
 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size,
-				    unsigned int width __maybe_unused)
+				    size_t size, unsigned int width)
 {
 	return _hist_entry__sym_snprintf(self->ms.map, self->ms.sym, self->ip,
 					 self->level, bf, size, width);
@@ -398,8 +397,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
-					size_t size,
-					unsigned int width __maybe_unused)
+					 size_t size, unsigned int width)
 {
 	struct addr_map_symbol *from = &self->branch_info->from;
 	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
@@ -408,8 +406,7 @@ static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
 }
 
 static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
-				       size_t size,
-				       unsigned int width __maybe_unused)
+				       size_t size, unsigned int width)
 {
 	struct addr_map_symbol *to = &self->branch_info->to;
 	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
-- 
1.8.1.1.361.gec3ae6e

