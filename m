Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3BFWBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:01:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3BFWBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:01:42 -0500
Date: Wed, 6 Feb 2013 14:01:14 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-74b2133d19e776924b2773e27dd9d6940f1cc594@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20130131125437.GA3656@quad>
References: <20130131125437.GA3656@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix set event list leader
Git-Commit-ID: 74b2133d19e776924b2773e27dd9d6940f1cc594
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:01:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74b2133d19e776924b2773e27dd9d6940f1cc594
Gitweb:     http://git.kernel.org/tip/74b2133d19e776924b2773e27dd9d6940f1cc594
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 31 Jan 2013 13:54:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:25 -0300

perf evlist: Fix set event list leader

The __perf_evlist__set_leader() was setting the leader for all events in
the list except the first. Which means it assumed the first event
already had event->leader = event.

Seems like this should be the role of the function to also do this. This
is a requirement for an upcoming patch set.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130131125437.GA3656@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index eddd5eb..ecf123e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -122,8 +122,7 @@ void __perf_evlist__set_leader(struct list_head *list)
 	leader->nr_members = evsel->idx - leader->idx + 1;
 
 	list_for_each_entry(evsel, list, node) {
-		if (evsel != leader)
-			evsel->leader = leader;
+		evsel->leader = leader;
 	}
 }
 
