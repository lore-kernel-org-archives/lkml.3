Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301Ab3FTKHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:07:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab3FTKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:07:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614624"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] bootmem, numa: Fix a comment typo in register_page_bootmem_info_node()
Date: Thu, 20 Jun 2013 18:10:23 +0800
Message-Id: <1371723023-4060-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:17,
	Serialize complete at 2013/06/20 18:06:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memory_hotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1ad92b4..12ee2a0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -220,13 +220,13 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 	pfn = pgdat->node_start_pfn;
 	end_pfn = pgdat_end_pfn(pgdat);
 
-	/* register_section info */
+	/* register section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		/*
 		 * Some platforms can assign the same pfn to multiple nodes - on
 		 * node0 as well as nodeN.  To avoid registering a pfn against
 		 * multiple nodes we check that this pfn does not already
-		 * reside in some other node.
+		 * reside in some other nodes.
 		 */
 		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
 			register_page_bootmem_info_section(pfn);
-- 
1.7.1

