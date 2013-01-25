Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3AYLkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:40:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3AYLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:40:35 -0500
Date: Fri, 25 Jan 2013 03:40:01 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fb29a338b585ebcce793b8e4a6c62440c4574fa7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-4-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Fix --sort pid output
Git-Commit-ID: fb29a338b585ebcce793b8e4a6c62440c4574fa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:40:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb29a338b585ebcce793b8e4a6c62440c4574fa7
Gitweb:     http://git.kernel.org/tip/fb29a338b585ebcce793b8e4a6c62440c4574fa7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:21 -0300

perf sort: Fix --sort pid output

The "pid" sort key prints "Command: Pid" output but it's misaligned.
It's because of the offset of 6 was added to the column length during
the calculation in order to reserve an space for Pid part but it isn't
honored when printed.  The output before this patch was like this:

  # Overhead  Command:  Pid      Shared Object
  # ........  .............  .................
  #
      99.70%        noploop:17814  noploop
       0.29%        noploop:17814  [kernel.kallsyms]
       0.01%        noploop:17814  ld-2.15.so

Fix it by subtracting 6 for printing comm part.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c2836e..8b6d70b 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -60,7 +60,7 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s:%5d", width,
+	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
 			      self->thread->comm ?: "", self->thread->pid);
 }
 
