Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3DLBQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:16:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49770 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3DLBOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:44 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 19/25] dnuma: memlayout: add memory_add_physaddr_to_nid() for memory_hotplug
Date: Thu, 11 Apr 2013 18:13:51 -0700
Message-Id: <1365729237-29711-20-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-3620-0000-0000-000002001480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memlayout.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memlayout.c b/mm/memlayout.c
index 45e7df6..4dc6706 100644
--- a/mm/memlayout.c
+++ b/mm/memlayout.c
@@ -247,3 +247,19 @@ void memlayout_global_init(void)
 
 	memlayout_commit(ml);
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+/*
+ * Provides a default memory_add_physaddr_to_nid() for memory hotplug, unless
+ * overridden by the arch.
+ */
+__weak
+int memory_add_physaddr_to_nid(u64 start)
+{
+	int nid = memlayout_pfn_to_nid(PFN_DOWN(start));
+	if (nid == NUMA_NO_NODE)
+		return 0;
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
-- 
1.8.2.1

