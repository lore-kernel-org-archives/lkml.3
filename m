Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaFEOcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:32:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaFEOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:32:15 -0400
Date: Thu, 5 Jun 2014 07:31:52 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2ec85c628c4cecef0f82d177279c579aed0f9706@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1400858147-7155-2-git-send-email-jolsa@kernel.org>
References: <1400858147-7155-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove elide setup for SORT_MODE__MEMORY mode
Git-Commit-ID: 2ec85c628c4cecef0f82d177279c579aed0f9706
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

Commit-ID:  2ec85c628c4cecef0f82d177279c579aed0f9706
Gitweb:     http://git.kernel.org/tip/2ec85c628c4cecef0f82d177279c579aed0f9706
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 23 May 2014 17:15:46 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:34:53 +0200

perf tools: Remove elide setup for SORT_MODE__MEMORY mode

There's no need to setup elide of sort_dso sort entry again
with symbol_conf.dso_list list.

The only difference were list names of memory mode data,
which does not make much sense to me.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400858147-7155-2-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 254f583..2aba620 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1412,19 +1412,6 @@ void sort__setup_elide(FILE *output)
 		sort_entry__setup_elide(&sort_sym_to,
 					symbol_conf.sym_to_list,
 					"sym_to", output);
-	} else if (sort__mode == SORT_MODE__MEMORY) {
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"symbol_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"dso_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"mem", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"local_weight", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"tlb", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"snoop", output);
 	}
 
 	/*
