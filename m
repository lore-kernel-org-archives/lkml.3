Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaHMFQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaHMFQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:16:00 -0400
Date: Tue, 12 Aug 2014 22:15:43 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-m8ae5s5cuwyytitgb6iqilid@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use list_move in ordered_events_delete function
Git-Commit-ID: fa4e5c67a2d169b9ef83f51b94e1d4a562ddfc0f
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

Commit-ID:  fa4e5c67a2d169b9ef83f51b94e1d4a562ddfc0f
Gitweb:     http://git.kernel.org/tip/fa4e5c67a2d169b9ef83f51b94e1d4a562ddfc0f
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 15 Jun 2014 19:46:08 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:59 -0300

perf tools: Use list_move in ordered_events_delete function

As Namhyung pointed out we can use list_move in ordered_events_delete.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-m8ae5s5cuwyytitgb6iqilid@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 95f8211..be6a48c 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -96,8 +96,7 @@ ordered_events__new(struct ordered_events *oe, u64 timestamp)
 
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event)
 {
-	list_del(&event->list);
-	list_add(&event->list, &oe->cache);
+	list_move(&event->list, &oe->cache);
 	oe->nr_events--;
 }
 
