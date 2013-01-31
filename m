Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3AaMyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:54:45 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60730 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3AaMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:54:43 -0500
Date: Thu, 31 Jan 2013 13:54:37 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mingo@elte.hu, peterz@infradead.org, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: [PATCH] perf tools: fix set event list leader
Message-ID: <20130131125437.GA3656@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The __perf_evlist__set_leader() was setting the leader for all events
in the list except the first. Which means it assumed the first event
already had event->leader = event. Seems like this should be the role
of the function to also do this. This is a requirement for an upcoming
patch set.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dc8aee9..050d5bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -119,8 +119,7 @@ void __perf_evlist__set_leader(struct list_head *list)
 	leader = list_entry(list->next, struct perf_evsel, node);
 
 	list_for_each_entry(evsel, list, node) {
-		if (evsel != leader)
-			evsel->leader = leader;
+		evsel->leader = leader;
 	}
 }
 
