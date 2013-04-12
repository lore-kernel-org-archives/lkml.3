Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3DLBO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49682 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3DLBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:26 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 06/25] mm: add nid_zone() helper
Date: Thu, 11 Apr 2013 18:13:38 -0700
Message-Id: <1365729237-29711-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-3620-0000-0000-000002001449
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nid_zone(), which returns the zone corresponding to a given nid & zonenum.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mm.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9ddae00..1b6abae 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -708,9 +708,14 @@ static inline void page_nid_reset_last(struct page *page)
 }
 #endif
 
+static inline struct zone *nid_zone(int nid, enum zone_type zonenum)
+{
+	return &NODE_DATA(nid)->node_zones[zonenum];
+}
+
 static inline struct zone *page_zone(const struct page *page)
 {
-	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
+	return nid_zone(page_to_nid(page), page_zonenum(page));
 }
 
 #ifdef SECTION_IN_PAGE_FLAGS
-- 
1.8.2.1

