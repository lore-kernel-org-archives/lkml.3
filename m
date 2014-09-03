Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaICHs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:12777 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbaICHs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,455,1406617200"; 
   d="scan'208";a="567579828"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: akpm@linux-foundation.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] mm: Use min3/max3 macros to avoid shadow warnings
Date: Wed,  3 Sep 2014 00:48:17 -0700
Message-Id: <1409730497-25438-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Nested calls to min/max functions result in shadow warnings in
W=2 builds. Avoid the warning by using the min3 and max3 macros
to get the min/max of 3 values instead of nested calls.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 mm/page-writeback.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 91d73ef..35ca710 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1075,13 +1075,13 @@ static void bdi_update_dirty_ratelimit(struct backing_dev_info *bdi,
 	}
 
 	if (dirty < setpoint) {
-		x = min(bdi->balanced_dirty_ratelimit,
-			 min(balanced_dirty_ratelimit, task_ratelimit));
+		x = min3(bdi->balanced_dirty_ratelimit,
+			 balanced_dirty_ratelimit, task_ratelimit);
 		if (dirty_ratelimit < x)
 			step = x - dirty_ratelimit;
 	} else {
-		x = max(bdi->balanced_dirty_ratelimit,
-			 max(balanced_dirty_ratelimit, task_ratelimit));
+		x = max3(bdi->balanced_dirty_ratelimit,
+			 balanced_dirty_ratelimit, task_ratelimit);
 		if (dirty_ratelimit > x)
 			step = dirty_ratelimit - x;
 	}
-- 
1.9.3

