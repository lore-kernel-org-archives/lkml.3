Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbaGRMHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:07:17 -0400
Received: from 8bytes.org ([81.169.241.247]:47497 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbaGRMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:07:15 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 08:07:14 EDT
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6/6] PM / Hibernate: Touch Soft Lockup Watchdog in rtree_next_node
Date: Fri, 18 Jul 2014 13:57:23 +0200
Message-Id: <1405684643-30234-7-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When a memory bitmap is fully populated on a large memory
machine (several TB of RAM) it can take more than a minute
to walk through all bits. This causes the soft lockup
detector on these machine to report warnings.

Avoid this by touching the soft lockup watchdog in the
memory bitmap walking code.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 750b32f..c5d19a9 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -755,6 +755,7 @@ static bool rtree_next_node(struct memory_bitmap *bm)
 	if (&bm->cur.node->list != &bm->cur.zone->leaves) {
 		bm->cur.node_pfn += BM_BITS_PER_BLOCK;
 		bm->cur.node_bit  = 0;
+		touch_softlockup_watchdog();
 		return true;
 	}
 
-- 
1.9.1

