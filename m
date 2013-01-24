Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3AXSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:47:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3AXSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:47:29 -0500
Date: Thu, 24 Jan 2013 10:47:05 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5fa9041bbaa7a79a67d568b9c9f947db2f23d091@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1354171126-14387-8-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Link hist entry pairs to leader
Git-Commit-ID: 5fa9041bbaa7a79a67d568b9c9f947db2f23d091
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:47:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fa9041bbaa7a79a67d568b9c9f947db2f23d091
Gitweb:     http://git.kernel.org/tip/5fa9041bbaa7a79a67d568b9c9f947db2f23d091
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 29 Nov 2012 15:38:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf hists: Link hist entry pairs to leader

Current hists__match/link() link a leader to its pair, so if multiple
pairs were linked, the leader will lose pointer to previous pairs since
it was overwritten.  Fix it by making leader the list head.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1354171126-14387-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d2bc05c..82df1b2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -785,7 +785,7 @@ void hists__match(struct hists *leader, struct hists *other)
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
-			hist_entry__add_pair(pos, pair);
+			hist_entry__add_pair(pair, pos);
 	}
 }
 
@@ -806,7 +806,7 @@ int hists__link(struct hists *leader, struct hists *other)
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
 				return -1;
-			hist_entry__add_pair(pair, pos);
+			hist_entry__add_pair(pos, pair);
 		}
 	}
 
