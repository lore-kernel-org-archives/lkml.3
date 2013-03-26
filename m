Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3CZRqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:46:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36718 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3CZRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:46:49 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/3] page_alloc: make setup_nr_node_ids() usable for arch init code
Date: Tue, 26 Mar 2013 10:46:00 -0700
Message-Id: <1364319962-30967-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032617-3620-0000-0000-000001C7481F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc and x86 were opencoding copies of setup_nr_node_ids(), which
page_alloc provides but makes static. Make it avaliable to the archs in
linux/mm.h.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mm.h | 6 ++++++
 mm/page_alloc.c    | 6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7acc9dc..3405405 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1755,5 +1755,11 @@ static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#if MAX_NUMNODES > 1
+void __init setup_nr_node_ids(void);
+#else
+static inline void setup_nr_node_ids(void) {}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fcced7..96909bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4710,7 +4710,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 /*
  * Figure out the number of possible node ids.
  */
-static void __init setup_nr_node_ids(void)
+void __init setup_nr_node_ids(void)
 {
 	unsigned int node;
 	unsigned int highest = 0;
@@ -4719,10 +4719,6 @@ static void __init setup_nr_node_ids(void)
 		highest = node;
 	nr_node_ids = highest + 1;
 }
-#else
-static inline void setup_nr_node_ids(void)
-{
-}
 #endif
 
 /**
-- 
1.8.2

