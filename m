Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaH1TAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:00:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaH1Sg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:29 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 40/97] vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()
Date: Thu, 28 Aug 2014 19:34:48 +0100
Message-Id: <1409250945-30874-41-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

commit 83da7510058736c09a14b9c17ec7d851940a4332 upstream.

Seems to be called with preemption enabled.  Therefore it must use
mod_zone_page_state instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9de5a52..96cd5c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1144,7 +1144,7 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 			TTU_UNMAP|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
 }
 
-- 
1.8.4.5

