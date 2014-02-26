Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaBZDoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:44:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaBZDn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:43:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] perf, session: Change header.misc dump from decimal to hex
Date: Tue, 25 Feb 2014 22:43:46 -0500
Message-Id: <1393386227-149412-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
References: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing the raw dump of a data file, the header.misc is
printed as a decimal.  Unfortunately, that field is a bit mask, so
it is hard to interpret as a decimal.

Print in hex, so the user can easily see what bits are set and more
importantly what type of info it is conveying.

V2: add 0x in front per Jiri Olsa

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1d555d6..55960f2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -794,7 +794,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
+	printf("(IP, 0x%x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
-- 
1.7.11.7

