Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775AbaBGFIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:08:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52271 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGFIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:08:49 -0500
X-AuditID: 9c93016f-b7b0cae0000024a7-38-52f46a5f0fc5
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/5] compaction related commits
Date: Fri,  7 Feb 2014 14:08:41 +0900
Message-Id: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is related to the compaction.

patch 1 fixes contrary implementation of the purpose of compaction.
patch 2~4 are for optimization.
patch 5 is just for clean-up.

I tested this patchset with stress-highalloc benchmark on Mel's mmtest
and cannot find any regression in terms of success rate. And I find
much reduced system time. Below is result of 3 runs.

* Before
time :: stress-highalloc 3276.26 user 740.52 system 1664.79 elapsed
time :: stress-highalloc 3640.71 user 771.32 system 1633.83 elapsed
time :: stress-highalloc 3691.64 user 775.44 system 1638.05 elapsed

avg system: 1645 s

* After
time :: stress-highalloc 3225.51 user 732.40 system 1542.76 elapsed
time :: stress-highalloc 3524.31 user 749.63 system 1512.88 elapsed
time :: stress-highalloc 3610.55 user 757.20 system 1505.70 elapsed

avg system: 1519 s

That is 7% reduced system time.

Thanks.

Joonsoo Kim (5):
  mm/compaction: disallow high-order page for migration target
  mm/compaction: do not call suitable_migration_target() on every page
  mm/compaction: change the timing to check to drop the spinlock
  mm/compaction: check pageblock suitability once per pageblock
  mm/compaction: clean-up code on success of ballon isolation

 mm/compaction.c |   75 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

-- 
1.7.9.5

