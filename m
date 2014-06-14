Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaFNVT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:19:59 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:38077 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbaFNVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:19:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIAE+7nFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYRgI4EaN4hGAc9CF4VjiC9kHYQtBI9sileLMIgog0I7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/1] mm/internal.h: use nth_page
Date: Sat, 14 Jun 2014 23:20:05 +0200
Message-Id: <1402780805-8124-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use nth_page instead of pfn_to_page(page_to_pfn

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7f22a11f..a1b651b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -247,7 +247,7 @@ static inline void mlock_migrate_page(struct page *new, struct page *old) { }
 static inline struct page *mem_map_offset(struct page *base, int offset)
 {
 	if (unlikely(offset >= MAX_ORDER_NR_PAGES))
-		return pfn_to_page(page_to_pfn(base) + offset);
+		return nth_page(base, offset);
 	return base + offset;
 }
 
-- 
1.8.4.5

