Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaBJRau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:30:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaBJRao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 06/21] perf, stat: FIXME Stddev calculation is incorrect
Date: Mon, 10 Feb 2014 12:29:01 -0500
Message-Id: <1392053356-23024-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the standard deviation calculation.  The current calculation
does the standard deviation mean which is slightly different.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 6506b3d..58aa661 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -47,7 +47,8 @@ double stddev_stats(struct stats *stats)
 		return 0.0;
 
 	variance = stats->M2 / (stats->n - 1);
-	variance_mean = variance / stats->n;
+	//variance_mean = variance / stats->n;
+	variance_mean = variance;
 
 	return sqrt(variance_mean);
 }
-- 
1.7.11.7

