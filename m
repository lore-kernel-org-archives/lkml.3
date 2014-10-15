Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaJOKGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaJOKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:50 -0400
Date: Wed, 15 Oct 2014 03:05:59 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4955ea225db42144d1667838f908315a16d51c5b@git.kernel.org>
Cc: namhyung@kernel.org, jolsa@redhat.com, acme@redhat.com, dsahern@gmail.com,
        peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, eranian@google.com
Reply-To: namhyung@kernel.org, jolsa@redhat.com, acme@redhat.com,
        dsahern@gmail.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        eranian@google.com
In-Reply-To: <8761fwh1nc.fsf@sejong.aot.lge.com>
References: <8761fwh1nc.fsf@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fixup off-by-one comparision in maps__find
Git-Commit-ID: 4955ea225db42144d1667838f908315a16d51c5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4955ea225db42144d1667838f908315a16d51c5b
Gitweb:     http://git.kernel.org/tip/4955ea225db42144d1667838f908315a16d51c5b
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 14 Oct 2014 16:05:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:50:56 -0300

perf tools: Fixup off-by-one comparision in maps__find

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
index 186418b..2137c45 100644
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
