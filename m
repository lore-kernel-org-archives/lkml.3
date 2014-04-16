Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaDPSxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:53:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:61854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbaDPSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,873,1389772800"; 
   d="scan'208";a="521807597"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: [PATCH 10/10] perf, tools, record: Always allow to overide default period v2
Date: Wed, 16 Apr 2014 11:49:32 -0700
Message-Id: <1397674172-30959-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
References: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix the logic to allow overriding event default periods with -c or -F
on the command line.  I'm not sure I understand this if() fully, but
this change makes all cases I tested work (tracepoint with default, default,
,-c, -F)

This fixed specifying -c / -F with json event list events,
which have a default period. It should do the same
for trace point events.

Cc: fweisbec@gmail.com
v2: Simplify, just change || to &&
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5c28d82..d9ceede 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -592,7 +592,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	 * We default some events to a 1 default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
+	if (!attr->sample_period && (opts->user_freq != UINT_MAX &&
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
 			perf_evsel__set_sample_bit(evsel, PERIOD);
-- 
1.8.5.3

