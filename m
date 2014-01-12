Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaALSdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:33:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaALSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:33:05 -0500
Date: Sun, 12 Jan 2014 10:32:26 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-gjoam7wcfrb03sp753gk1nfk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Make symbol__inc_addr_samples private
Git-Commit-ID: 44e8303944cd45788abd48f14d4c683331ed6cf7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44e8303944cd45788abd48f14d4c683331ed6cf7
Gitweb:     http://git.kernel.org/tip/44e8303944cd45788abd48f14d4c683331ed6cf7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 17:12:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:33 -0300

perf annotate: Make symbol__inc_addr_samples private

Since it is now accessed just thru addr_map_symbol and hist_entry
wrappers.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gjoam7wcfrb03sp753gk1nfk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 4 ++--
 tools/perf/util/annotate.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 91e2526..27ab7b5 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -486,8 +486,8 @@ static int __symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	return 0;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
-			     int evidx, u64 addr)
+static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+				    int evidx, u64 addr)
 {
 	struct annotation *notes;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 43727a9..b2aef59 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -132,9 +132,6 @@ static inline struct annotation *symbol__annotation(struct symbol *sym)
 	return &a->annotation;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
-			     int evidx, u64 addr);
-
 int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
 
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 addr);
