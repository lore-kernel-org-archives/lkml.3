Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3KDGzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:55:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3KDGy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:54:57 -0500
Date: Sun, 3 Nov 2013 22:54:41 -0800
From: tip-bot for Wei Yang <tipbot@zytor.com>
Message-ID: <tip-32bf5bd181026fc99c0e15045abe409167285ba8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, weiyang@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        weiyang@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Fix two warnings
Git-Commit-ID: 32bf5bd181026fc99c0e15045abe409167285ba8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 03 Nov 2013 22:54:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32bf5bd181026fc99c0e15045abe409167285ba8
Gitweb:     http://git.kernel.org/tip/32bf5bd181026fc99c0e15045abe409167285ba8
Author:     Wei Yang <weiyang@linux.vnet.ibm.com>
AuthorDate: Sun, 22 Sep 2013 16:49:24 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 1 Nov 2013 10:41:54 -0300

perf bench: Fix two warnings

There are two warnings in bench/numa, when building this on 32-bit
machine.

The warning output is attached:

bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of t'long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]

This patch fixes these two warnings.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..a73c4ed 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if (diff.tv_sec >= (time_t)g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1157,7 +1157,7 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"]\n",
 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
 			}
 			fflush(stdout);
