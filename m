Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3DLBQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:16:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49776 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3DLBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:45 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 21/25] mm/memory_hotplug: VM_BUG if nid is too large.
Date: Thu, 11 Apr 2013 18:13:53 -0700
Message-Id: <1365729237-29711-22-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-3620-0000-0000-000002001485
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f5ea9b7..5fcd29e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1063,6 +1063,8 @@ int __mem_online_node(int nid)
 	pg_data_t *pgdat;
 	int ret;
 
+	VM_BUG_ON(nid >= nr_node_ids);
+
 	pgdat = hotadd_new_pgdat(nid, 0);
 	if (!pgdat)
 		return -ENOMEM;
-- 
1.8.2.1

