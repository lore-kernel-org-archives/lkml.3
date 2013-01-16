Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3APA0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:26:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55775 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab3APA0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:50 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 12/17] mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the same.
Date: Tue, 15 Jan 2013 16:24:49 -0800
Message-Id: <1358295894-24167-13-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-5518-0000-0000-00000AC4D959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Replace open coded pgdat_end_pfn() with helper function.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8e352fe..0a74b86a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -189,7 +189,7 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 	}
 
 	pfn = pgdat->node_start_pfn;
-	end_pfn = pfn + pgdat->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(pgdat);
 
 	/* register_section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-- 
1.8.0.3

