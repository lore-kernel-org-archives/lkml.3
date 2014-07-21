Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaGUK10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:27:26 -0400
Received: from 8bytes.org ([81.169.241.247]:50857 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbaGUK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:27:08 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6/6] PM / Hibernate: Touch Soft Lockup Watchdog in rtree_next_node
Date: Mon, 21 Jul 2014 12:27:02 +0200
Message-Id: <1405938422-21900-7-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405938422-21900-1-git-send-email-joro@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
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
index 6a4e07e..738d930 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -769,6 +769,7 @@ static bool rtree_next_node(struct memory_bitmap *bm)
 	if (&bm->cur.node->list != &bm->cur.zone->leaves) {
 		bm->cur.node_pfn += BM_BITS_PER_BLOCK;
 		bm->cur.node_bit  = 0;
+		touch_softlockup_watchdog();
 		return true;
 	}
 
-- 
1.9.1

