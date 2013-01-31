Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3AaKl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:41:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3AaKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:41:25 -0500
Date: Thu, 31 Jan 2013 02:40:47 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-42ldngi973f4ssvzlklo8t2k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem: Use memdup()
Git-Commit-ID: 8d9233f205e8855dc762665e28012354cd46af45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:40:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d9233f205e8855dc762665e28012354cd46af45
Gitweb:     http://git.kernel.org/tip/8d9233f205e8855dc762665e28012354cd46af45
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 22:24:57 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jan 2013 12:49:28 -0300

perf kmem: Use memdup()

Instead of hand coded equivalent.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-42ldngi973f4ssvzlklo8t2k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c746108..46878da 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include <linux/rbtree.h>
+#include <linux/string.h>
 
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
@@ -618,12 +619,11 @@ static int sort_dimension__add(const char *tok, struct list_head *list)
 
 	for (i = 0; i < NUM_AVAIL_SORTS; i++) {
 		if (!strcmp(avail_sorts[i]->name, tok)) {
-			sort = malloc(sizeof(*sort));
+			sort = memdup(avail_sorts[i], sizeof(*avail_sorts[i]));
 			if (!sort) {
-				pr_err("%s: malloc failed\n", __func__);
+				pr_err("%s: memdup failed\n", __func__);
 				return -1;
 			}
-			memcpy(sort, avail_sorts[i], sizeof(*sort));
 			list_add_tail(&sort->list, list);
 			return 0;
 		}
