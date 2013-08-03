Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3HCAlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:41:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:11835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab3HCAlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="375428878"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: eranian@google.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, tools: flush output after each line in stat interval mode
Date: Fri,  2 Aug 2013 17:41:12 -0700
Message-Id: <1375490473-1503-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When interval mode is outputting to a pipe, each measurement
should be flushed individually, so that the reader sees it
timely.

With a terminal each line is automatically flushed by stdio,
but that is disabled with non terminal output.

Simply fflush output after each time interval

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e637e4..f686d5f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -416,6 +416,8 @@ static void print_interval(void)
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, prefix);
 	}
+
+	fflush(output);
 }
 
 static void handle_initial_delay(void)
-- 
1.8.3.1

