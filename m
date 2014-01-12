Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaALScV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:32:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaALSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:31:45 -0500
Date: Sun, 12 Jan 2014 10:31:17 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f1cbf78d175e6202a29f53a7f915520e40a37baf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        asharma@fb.com
In-Reply-To: <1387344086-12744-4-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Do not pass period and weight to add_hist_entry()
Git-Commit-ID: f1cbf78d175e6202a29f53a7f915520e40a37baf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:31:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1cbf78d175e6202a29f53a7f915520e40a37baf
Gitweb:     http://git.kernel.org/tip/f1cbf78d175e6202a29f53a7f915520e40a37baf
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 18 Dec 2013 14:21:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Dec 2013 14:44:05 -0300

perf hists: Do not pass period and weight to add_hist_entry()

The @entry argument already has the info so no need to pass them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1387344086-12744-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 822903e..63234e3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -342,15 +342,15 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 }
 
 static struct hist_entry *add_hist_entry(struct hists *hists,
-				      struct hist_entry *entry,
-				      struct addr_location *al,
-				      u64 period,
-				      u64 weight)
+					 struct hist_entry *entry,
+					 struct addr_location *al)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int64_t cmp;
+	u64 period = entry->stat.period;
+	u64 weight = entry->stat.weight;
 
 	p = &hists->entries_in->rb_node;
 
@@ -437,7 +437,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al, period, weight);
+	return add_hist_entry(hists, &entry, al);
 }
 
 int64_t
