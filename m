Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFJRyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:54:35 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:3214 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbaFJRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:54:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQNAL9Cl1NbskA7/2dsb2JhbABZgw2sFAEBBpkSgQgXdYRgI4EaN4hGAcxshVaIcx2EKwSPXYpHiyiIHYM+Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/1] mm/memory_hotplug.c: add __meminit to grow_zone_span/grow_pgdat_span
Date: Tue, 10 Jun 2014 19:53:13 +0200
Message-Id: <1402422793-5928-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

grow_zone_span and grow_pgdat_span are only called by
__meminit __add_zone

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/memory_hotplug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 469bbf5..3557e8c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -284,8 +284,8 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 }
 #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
-static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
-			   unsigned long end_pfn)
+static void __meminit grow_zone_span(struct zone *zone, unsigned long start_pfn,
+				     unsigned long end_pfn)
 {
 	unsigned long old_zone_end_pfn;
 
@@ -427,8 +427,8 @@ out_fail:
 	return -1;
 }
 
-static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
-			    unsigned long end_pfn)
+static void __meminit grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
+				      unsigned long end_pfn)
 {
 	unsigned long old_pgdat_end_pfn = pgdat_end_pfn(pgdat);
 
-- 
1.8.4.5

