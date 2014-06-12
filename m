Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbaFLMDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaFLMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:03:15 -0400
Date: Thu, 12 Jun 2014 05:03:03 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-7365be55eee37ddb4f487263b4ba5bc8beb9638f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1401208087-181977-6-git-send-email-dzickus@redhat.com>
References: <1401208087-181977-6-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add cpumode to struct hist_entry
Git-Commit-ID: 7365be55eee37ddb4f487263b4ba5bc8beb9638f
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

Commit-ID:  7365be55eee37ddb4f487263b4ba5bc8beb9638f
Gitweb:     http://git.kernel.org/tip/7365be55eee37ddb4f487263b4ba5bc8beb9638f
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 27 May 2014 12:28:05 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 13:34:48 +0200

perf tools: Add cpumode to struct hist_entry

The next patch needs to sort on cpumode, so add it to hist_entry to be tracked.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401208087-181977-6-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 7 ++++---
 tools/perf/util/sort.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a0a4b2..d5f47a4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -439,9 +439,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.map	= al->map,
 			.sym	= al->sym,
 		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
+		.cpu	 = al->cpu,
+		.cpumode = al->cpumode,
+		.ip	 = al->addr,
+		.level	 = al->level,
 		.stat = {
 			.nr_events = 1,
 			.period	= period,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 5bf0098..6de22f8 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -89,6 +89,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
