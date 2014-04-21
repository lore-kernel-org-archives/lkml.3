Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaDUSIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:08:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:55684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbaDUSIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,897,1389772800"; 
   d="scan'208";a="524398612"
Subject: [PATCH] mm: debug: make bad_range() output more usable and readable
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 21 Apr 2014 11:07:33 -0700
Message-Id: <20140421180733.30BD5EFE@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Nobody outputs memory addresses in decimal.  PFNs are essentially
addresses, and they're gibberish in decimal.  Output them in hex.

Also, add the nid and zone name to give a little more context to
the message.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~range-in-hex mm/page_alloc.c
--- a/mm/page_alloc.c~range-in-hex	2014-04-21 10:11:32.274712151 -0700
+++ b/mm/page_alloc.c	2014-04-21 10:11:32.279712378 -0700
@@ -261,8 +261,9 @@ static int page_outside_zone_boundaries(
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
-		pr_err("page %lu outside zone [ %lu - %lu ]\n",
-			pfn, start_pfn, start_pfn + sp);
+		pr_err("page 0x%lx outside node %d zone %s [ 0x%lx - 0x%lx ]\n",
+			pfn, zone_to_nid(zone), zone->name,
+			start_pfn, start_pfn + sp);
 
 	return ret;
 }
_
