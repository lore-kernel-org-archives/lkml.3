Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3ASBag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:30:36 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52490 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3ASBad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:30:33 -0500
Date: Fri, 18 Jan 2013 17:30:52 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: acme@ghostprotocols.net, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] perf: Fix compile warnings in tests/attr.c
Message-ID: <20130119013052.GA24693@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011901-4834-0000-0000-000002C037D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d266e5040c33103f5d226b0d16b89f8ef79e3ad Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 18 Jan 2013 11:14:28 -0800
Subject: [PATCH] perf: Fix compile warnings in tests/attr.c

Replace '%llu' in printf()s with 'PRIu64' in 'tools/perf/tests/attr.c'
to fix compile warnings (which become errors due to -Werror).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/tests/attr.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index f61dd3f..5cbb2b3 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -65,7 +65,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	FILE *file;
 	char path[PATH_MAX];
 
-	snprintf(path, PATH_MAX, "%s/event-%d-%llu-%d", dir,
+	snprintf(path, PATH_MAX, "%s/event-%d-%" PRIu64 "-%d", dir,
 		 attr->type, attr->config, fd);
 
 	file = fopen(path, "w+");
@@ -74,7 +74,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 		return -1;
 	}
 
-	if (fprintf(file, "[event-%d-%llu-%d]\n",
+	if (fprintf(file, "[event-%d-%" PRIu64 "-%d]\n",
 		    attr->type, attr->config, fd) < 0) {
 		perror("test attr - failed to write event file");
 		fclose(file);
@@ -91,10 +91,10 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	/* struct perf_event_attr */
 	WRITE_ASS(type,   PRIu32);
 	WRITE_ASS(size,   PRIu32);
-	WRITE_ASS(config,  "llu");
-	WRITE_ASS(sample_period, "llu");
-	WRITE_ASS(sample_type,   "llu");
-	WRITE_ASS(read_format,   "llu");
+	WRITE_ASS(config,  PRIu64);
+	WRITE_ASS(sample_period, PRIu64);
+	WRITE_ASS(sample_type,   PRIu64);
+	WRITE_ASS(read_format,   PRIu64);
 	WRITE_ASS(disabled,       "d");
 	WRITE_ASS(inherit,        "d");
 	WRITE_ASS(pinned,         "d");
@@ -119,10 +119,10 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	WRITE_ASS(exclude_callchain_user, "d");
 	WRITE_ASS(wakeup_events, PRIu32);
 	WRITE_ASS(bp_type, PRIu32);
-	WRITE_ASS(config1, "llu");
-	WRITE_ASS(config2, "llu");
-	WRITE_ASS(branch_sample_type, "llu");
-	WRITE_ASS(sample_regs_user,   "llu");
+	WRITE_ASS(config1, PRIu64);
+	WRITE_ASS(config2, PRIu64);
+	WRITE_ASS(branch_sample_type, PRIu64);
+	WRITE_ASS(sample_regs_user,   PRIu64);
 	WRITE_ASS(sample_stack_user,  PRIu32);
 
 	fclose(file);
-- 
1.7.1

