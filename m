Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaBJRac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaBJRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:28 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 05/21] perf, session: Change header.misc dump from decimal to hex
Date: Mon, 10 Feb 2014 12:29:00 -0500
Message-Id: <1392053356-23024-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing the raw dump of a data file, the header.misc is
printed as a decimal.  Unfortunately, that field is a bit mask, so
it is hard to interpret as a decimal.

Print in hex, so the user can easily see what bits are set and more
importantly what type of info it is conveying.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0b39a48..d1ad10f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -793,7 +793,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
+	printf("(IP, %x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
-- 
1.7.11.7

