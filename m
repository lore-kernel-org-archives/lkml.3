Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3AXUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:32:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3AXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 54/74] perf tools: Mark branch_info maps as referenced
Date: Thu, 24 Jan 2013 17:08:03 -0300
Message-Id: <1359058103-31645-55-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

As noticed by Jiri, the hist_entry->branch_info.to/from maps need to be
marked as referenced to avoid problems later on.  So we do this when the
hist_entry is allocated.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130114140245.GA4692@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9485c70..8170a3d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -245,6 +245,14 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
+
+		if (he->branch_info) {
+			if (he->branch_info->from.map)
+				he->branch_info->from.map->referenced = true;
+			if (he->branch_info->to.map)
+				he->branch_info->to.map->referenced = true;
+		}
+
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
-- 
1.8.1.1.361.gec3ae6e

