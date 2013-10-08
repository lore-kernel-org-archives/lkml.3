Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3JHKnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:43:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3JHKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:54 -0400
Date: Tue, 8 Oct 2013 03:40:30 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d20a47e70b57a77f4d1b0dba98a668e14c2f9bf9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
References: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  Set child_pid after perf_evlist__prepare_workload()
Git-Commit-ID: d20a47e70b57a77f4d1b0dba98a668e14c2f9bf9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:40:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d20a47e70b57a77f4d1b0dba98a668e14c2f9bf9
Gitweb:     http://git.kernel.org/tip/d20a47e70b57a77f4d1b0dba98a668e14c2f9bf9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Sep 2013 18:01:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:16:05 -0300

perf stat: Set child_pid after perf_evlist__prepare_workload()

The commit acf2892270dc ("perf stat: Use perf_evlist__prepare/
start_workload()") converted to use the function but forgot to update
child_pid.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380531671-28076-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..5098f14 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
 			perror("failed to prepare workload");
 			return -1;
 		}
+		child_pid = evsel_list->workload.pid;
 	}
 
 	if (group)
