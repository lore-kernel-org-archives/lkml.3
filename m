Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaJOKGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaJOKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:43 -0400
Date: Wed, 15 Oct 2014 03:06:11 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ivbrj08sjakxdwkrcndbkoig@git.kernel.org>
Cc: eranian@google.com, jolsa@redhat.com, tglx@linutronix.de,
        peterz@infradead.org, adrian.hunter@intel.com, dsahern@gmail.com,
        hpa@zytor.com, mingo@kernel.org, acme@redhat.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, namhyung@kernel.org, mingo@kernel.org,
        hpa@zytor.com, acme@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, peterz@infradead.org, jolsa@redhat.com,
        tglx@linutronix.de, eranian@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix map->end fixup
Git-Commit-ID: eba85230de892e2a925c85dca1fe177e8b3d84d8
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

Commit-ID:  eba85230de892e2a925c85dca1fe177e8b3d84d8
Gitweb:     http://git.kernel.org/tip/eba85230de892e2a925c85dca1fe177e8b3d84d8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Oct 2014 16:39:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:50:57 -0300

perf symbols: Fix map->end fixup

When synthesizing maps from files that have incomplete symbol
information, like kallsyms, we need to fixup the end of maps by seting
its end from the ->start of the next map, fix it to set prev_map->end to
curr_map->start, since ->end is the first byte outside prev_map address
range.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ivbrj08sjakxdwkrcndbkoig@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index be84f7a..c787a43 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -207,7 +207,7 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
 		prev = curr;
 		curr = rb_entry(nd, struct map, rb_node);
-		prev->end = curr->start - 1;
+		prev->end = curr->start;
 	}
 
 	/*
