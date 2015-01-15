Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbbAOWSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbbAOWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:18:48 -0500
Date: Fri, 16 Jan 2015 00:18:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org
Subject: [PATCH] mm/vmscan: fix highidx argument type
Message-ID: <1421360175-18899-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_zone_zonelist_nodemask wants an enum zone_type
argument, but is passed gfp_t:

mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask
mm/vmscan.c:2658:9: warning: incorrect type in argument 2 (different base types)
mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask

convert argument to the correct type.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

In case this was already fixed, pls ignore - seems to still be
there in latest master.

 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ab2505c..dcd90c8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2656,7 +2656,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	 * should make reasonable progress.
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_mask, nodemask) {
+					gfp_zone(gfp_mask), nodemask) {
 		if (zone_idx(zone) > ZONE_NORMAL)
 			continue;
 
-- 
MST
