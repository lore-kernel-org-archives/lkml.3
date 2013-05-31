Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3EaLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:25:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:25:49 -0400
Date: Fri, 31 May 2013 04:25:29 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-930477bdc227adbbff1d42ec9eba50a805cc9b78@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1365125198-8334-7-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Cleanup sort__has_sym setting
Git-Commit-ID: 930477bdc227adbbff1d42ec9eba50a805cc9b78
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

Commit-ID:  930477bdc227adbbff1d42ec9eba50a805cc9b78
Gitweb:     http://git.kernel.org/tip/930477bdc227adbbff1d42ec9eba50a805cc9b78
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Apr 2013 10:26:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:56 +0300

perf sort: Cleanup sort__has_sym setting

The sort__has_sym variable is set only if a symbol-related sort key was
added.  Since branch stack and memory sort dimensions are separated, it
doesn't need to be checked from common dimension.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1365125198-8334-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 701ab1d..313a5a7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -938,10 +938,7 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym ||
-			   sd->entry == &sort_sym_from ||
-			   sd->entry == &sort_sym_to ||
-			   sd->entry == &sort_mem_daddr_sym) {
+		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
 		}
 
