Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaJNVGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:45065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaJNVGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:38 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/24] perf tools: Fixup off-by-one comparision in maps__find
Date: Tue, 14 Oct 2014 18:04:31 -0300
Message-Id: <1413320673-5784-23-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

map->end is the first addr _outside_ the a map, following the convention
of vm_area_struct->vm_end.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/8761fwh1nc.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 186418ba18db..2137c4596ec7 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 		m = rb_entry(parent, struct map, rb_node);
 		if (ip < m->start)
 			p = &(*p)->rb_left;
-		else if (ip > m->end)
+		else if (ip >= m->end)
 			p = &(*p)->rb_right;
 		else
 			return m;
-- 
1.9.3

