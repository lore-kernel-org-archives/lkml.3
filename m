Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3AXUSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:18:38 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54088
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755923Ab3AXUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 47/74] perf sort: Clean up sort__first_dimension setting
Date: Thu, 24 Jan 2013 17:07:56 -0300
Message-Id: <1359058103-31645-48-git-send-email-acme@infradead.org>
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

It doesn't need to compare to every sort key names since the index
already has the required information.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a36051b..39b1ab0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -526,30 +526,8 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry->se_collapse)
 			sort__need_collapse = 1;
 
-		if (list_empty(&hist_entry__sort_list)) {
-			if (!strcmp(sd->name, "pid"))
-				sort__first_dimension = SORT_PID;
-			else if (!strcmp(sd->name, "comm"))
-				sort__first_dimension = SORT_COMM;
-			else if (!strcmp(sd->name, "dso"))
-				sort__first_dimension = SORT_DSO;
-			else if (!strcmp(sd->name, "symbol"))
-				sort__first_dimension = SORT_SYM;
-			else if (!strcmp(sd->name, "parent"))
-				sort__first_dimension = SORT_PARENT;
-			else if (!strcmp(sd->name, "cpu"))
-				sort__first_dimension = SORT_CPU;
-			else if (!strcmp(sd->name, "symbol_from"))
-				sort__first_dimension = SORT_SYM_FROM;
-			else if (!strcmp(sd->name, "symbol_to"))
-				sort__first_dimension = SORT_SYM_TO;
-			else if (!strcmp(sd->name, "dso_from"))
-				sort__first_dimension = SORT_DSO_FROM;
-			else if (!strcmp(sd->name, "dso_to"))
-				sort__first_dimension = SORT_DSO_TO;
-			else if (!strcmp(sd->name, "mispredict"))
-				sort__first_dimension = SORT_MISPREDICT;
-		}
+		if (list_empty(&hist_entry__sort_list))
+			sort__first_dimension = i;
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
-- 
1.8.1.1.361.gec3ae6e

