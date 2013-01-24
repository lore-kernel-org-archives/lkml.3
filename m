Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3AXSqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:46:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AXSqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:46:22 -0500
Date: Thu, 24 Jan 2013 10:46:01 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-8jdq8g6kl6v54hkexrfwsy72@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Fix typo on hist__entry_add_pair
Git-Commit-ID: 2850d9487266a55a18d340c24f5107696deeebb9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:46:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2850d9487266a55a18d340c24f5107696deeebb9
Gitweb:     http://git.kernel.org/tip/2850d9487266a55a18d340c24f5107696deeebb9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 29 Nov 2012 14:38:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf hists: Fix typo on hist__entry_add_pair

Fix a misplaced underscore.  In this case, 'hist_entry' is the name of
data structure and we usually put double underscores between data
structure and actual function name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8jdq8g6kl6v54hkexrfwsy72@git.kernel.org
[ committer note: put it in front of the patch queue where it came from ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 4 ++--
 tools/perf/util/sort.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..d2bc05c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -785,7 +785,7 @@ void hists__match(struct hists *leader, struct hists *other)
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
-			hist__entry_add_pair(pos, pair);
+			hist_entry__add_pair(pos, pair);
 	}
 }
 
@@ -806,7 +806,7 @@ int hists__link(struct hists *leader, struct hists *other)
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
 				return -1;
-			hist__entry_add_pair(pair, pos);
+			hist_entry__add_pair(pair, pos);
 		}
 	}
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b4e8c3b..91ae274 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -118,7 +118,7 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist__entry_add_pair(struct hist_entry *he,
+static inline void hist_entry__add_pair(struct hist_entry *he,
 					struct hist_entry *pair)
 {
 	list_add_tail(&he->pairs.head, &pair->pairs.node);
