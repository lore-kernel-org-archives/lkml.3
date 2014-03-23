Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaCWU03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 16:26:29 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:50109 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbaCWU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:26:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4OALJCL1NbsnCH/2dsb2JhbABZgwaCSX4TwCYCAoEPF3SCZhwjGIECJBOHfQHNTI56hD8EmEkBilmHWIMuPA
Date: Sun, 23 Mar 2014 21:27:56 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/memblock.c: use PFN_PHYS()
Message-Id: <20140323212756.6c3777f1b8e4c7fe0e1168a9@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ((phys_addr_t)(x) << PAGE_SHIFT) by pfn macro.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/memblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 39a31e7..955ec04 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1253,7 +1253,7 @@ phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
 		pages += end_pfn - start_pfn;
 	}
 
-	return (phys_addr_t)pages << PAGE_SHIFT;
+	return PFN_PHYS(pages);
 }
 
 /* lowest address */
@@ -1326,7 +1326,7 @@ int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
 			 unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	struct memblock_type *type = &memblock.memory;
-	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
+	int mid = memblock_search(type, PFN_PHYS(pfn));
 
 	if (mid == -1)
 		return -1;
-- 
1.8.4.5

