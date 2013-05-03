Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295Ab3ECAH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:07:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55289 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760563Ab3ECABp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:45 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 25/31] dnuma: memlayout: add memory_add_physaddr_to_nid() for memory_hotplug
Date: Thu,  2 May 2013 17:00:57 -0700
Message-Id: <1367539263-19999-26-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B9E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memlayout.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memlayout.c b/mm/memlayout.c
index 8b9ba9a..3e89482 100644
--- a/mm/memlayout.c
+++ b/mm/memlayout.c
@@ -336,3 +336,19 @@ void memlayout_global_init(void)
 
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
1.8.2.2

