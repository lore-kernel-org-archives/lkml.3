Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3AQW4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:56:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36636 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3AQWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:17 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 4/9] mm/page_alloc: add a VM_BUG in __free_one_page() if the zone is uninitialized.
Date: Thu, 17 Jan 2013 14:52:56 -0800
Message-Id: <1358463181-17956-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-2876-0000-0000-0000043302F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Freeing pages to uninitialized zones is not handled by
__free_one_page(), and should never happen when the code is correct.

Ran into this while writing some code that dynamically onlines extra
zones.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2574ea..f8ed277 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -530,6 +530,8 @@ static inline void __free_one_page(struct page *page,
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
 
+	VM_BUG_ON(!zone_is_initialized(zone));
+
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
 			return;
-- 
1.8.0.3

