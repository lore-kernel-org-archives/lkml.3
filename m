Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaDNOyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:54:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:54:06 -0400
Date: Mon, 14 Apr 2014 07:53:53 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-5673872d4afd2584e075cf2b1adb2cccec46a0f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395964219-22173-4-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-4-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Fix segfault at the end of an 'all'
  execution
Git-Commit-ID: 5673872d4afd2584e075cf2b1adb2cccec46a0f3
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

Commit-ID:  5673872d4afd2584e075cf2b1adb2cccec46a0f3
Gitweb:     http://git.kernel.org/tip/5673872d4afd2584e075cf2b1adb2cccec46a0f3
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 27 Mar 2014 19:50:19 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:53 +0200

perf bench: Fix segfault at the end of an 'all' execution

At the end of

  $ perf bench all

the program segfaults because it attempts to dereference a NULL
pointer. Fix this fault.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395964219-22173-4-git-send-email-artagnon@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index f600b74..1e6e777 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -86,7 +86,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
