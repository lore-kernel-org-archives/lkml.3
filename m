Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3AYLoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:44:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYLoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:44:00 -0500
Date: Fri, 25 Jan 2013 03:43:32 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-6f38cf25a6af5b21da1d52a94d9f56f5af2a215b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-9-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Clean up sort__first_dimension setting
Git-Commit-ID: 6f38cf25a6af5b21da1d52a94d9f56f5af2a215b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:43:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f38cf25a6af5b21da1d52a94d9f56f5af2a215b
Gitweb:     http://git.kernel.org/tip/6f38cf25a6af5b21da1d52a94d9f56f5af2a215b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:25 -0300

perf sort: Clean up sort__first_dimension setting

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
