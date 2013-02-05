Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3BEXRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:17:20 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3BEXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:17:17 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-eb-511192fa3d45
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Minchan Kim <minchan@kernel.org>, Shaohua Li <shli@kernel.org>
Subject: [PATCH] mm: Get rid of lockdep whinge on sys_swapon
Date: Wed,  6 Feb 2013 08:17:12 +0900
Message-Id: <1360106232-15501-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] forgot to initialize spin_lock so lockdep is whingeing
about it. This patch fixes it.

[1] 0f181e0e4, swap: add per-partition lock for swapfile

Cc: Shaohua Li <shli@kernel.org>
Reported/Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/swapfile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dfaff5f..ac190d6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1857,6 +1857,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
+	spin_lock_init(&p->lock);
 
 	return p;
 }
-- 
1.8.1.1

