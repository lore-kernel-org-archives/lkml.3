Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3ECABq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:01:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54756 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762056Ab3ECABT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:19 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 06/31] mm: add nid_zone() helper
Date: Thu,  2 May 2013 17:00:38 -0700
Message-Id: <1367539263-19999-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B8A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nid_zone(), which returns the zone corresponding to a given nid & zonenum.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mm.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1a7f19e..2004713 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -711,9 +711,14 @@ static inline void page_nid_reset_last(struct page *page)
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
1.8.2.2

