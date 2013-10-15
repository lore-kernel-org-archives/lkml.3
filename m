Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3JOFp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:45:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab3JOFZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:13 -0400
Date: Mon, 14 Oct 2013 22:24:38 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-60a25cbc4a167fc0129296c3c640d8506a57acc5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1378693159-8747-7-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-7-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Limit bad rate precision
Git-Commit-ID: 60a25cbc4a167fc0129296c3c640d8506a57acc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:24:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60a25cbc4a167fc0129296c3c640d8506a57acc5
Gitweb:     http://git.kernel.org/tip/60a25cbc4a167fc0129296c3c640d8506a57acc5
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sun, 8 Sep 2013 19:19:18 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:23:54 -0300

perf lock: Limit bad rate precision

Two decimal precision should be enough for this.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-7-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 780484f..972310c 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -686,7 +686,7 @@ static void print_bad_events(int bad, int total)
 
 	pr_info("\n=== output for debug===\n\n");
 	pr_info("bad: %d, total: %d\n", bad, total);
-	pr_info("bad rate: %f %%\n", (double)bad / (double)total * 100);
+	pr_info("bad rate: %.2f %%\n", (double)bad / (double)total * 100);
 	pr_info("histogram of events caused bad sequence\n");
 	for (i = 0; i < BROKEN_MAX; i++)
 		pr_info(" %10s: %d\n", name[i], bad_hist[i]);
