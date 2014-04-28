Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaD1UYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:24:17 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:25418 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbaD1UYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:24:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUUAP+3XlNXQw00/2dsb2JhbABZgwaCQKlNBQEBAQWZcgICgRoXdIJTExwjGIECJBOIRQHJGoVaiH+EQAEDjnyKDwGKc4drgzM7
Date: Mon, 28 Apr 2014 22:26:19 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/memblock.c: use PFN_DOWN
Message-Id: <20140428222619.ae74ca75971d8d9002784419@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ((x) >> PAGE_SHIFT) by pfn macro.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/memblock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e9d6ca9..b459009 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1329,9 +1329,8 @@ int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
 	if (mid == -1)
 		return -1;
 
-	*start_pfn = type->regions[mid].base >> PAGE_SHIFT;
-	*end_pfn = (type->regions[mid].base + type->regions[mid].size)
-			>> PAGE_SHIFT;
+	*start_pfn = PFN_DOWN(type->regions[mid].base);
+	*end_pfn = PFN_DOWN(type->regions[mid].base + type->regions[mid].size);
 
 	return type->regions[mid].nid;
 }
-- 
1.8.4.5

