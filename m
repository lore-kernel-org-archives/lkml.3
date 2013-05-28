Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab3E1XsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:48:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:32975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759335Ab3E1XsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:48:05 -0400
X-Greylist: delayed 1445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 19:48:04 EDT
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <liuj97@gmail.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-mm@kvack.org
Subject: [PATCH] Memory hotplug: Move alternative function definitions to header
Date: Wed, 29 May 2013 01:32:39 +0200
Message-ID: <3399422.RK6bMrAa5x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move the definitions of offline_pages() and remove_memory()
for CONFIG_MEMORY_HOTREMOVE to memory_hotplug.h, where they belong,
and make them static inline.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of the linux-next branch of the linux-pm.git tree.

Please let me know if there are any objections.

Thanks,
Rafael

---
 include/linux/memory_hotplug.h |    9 +++++++++
 mm/memory_hotplug.c            |    8 +-------
 2 files changed, 10 insertions(+), 7 deletions(-)

Index: linux-pm/include/linux/memory_hotplug.h
===================================================================
--- linux-pm.orig/include/linux/memory_hotplug.h
+++ linux-pm/include/linux/memory_hotplug.h
@@ -234,6 +234,8 @@ static inline void unlock_memory_hotplug
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
 extern void try_offline_node(int nid);
+extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern void remove_memory(int nid, u64 start, u64 size);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -243,6 +245,13 @@ static inline int is_mem_section_removab
 }
 
 static inline void try_offline_node(int nid) {}
+
+static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+{
+	return -EINVAL;
+}
+
+static inline void remove_memory(int nid, u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
Index: linux-pm/mm/memory_hotplug.c
===================================================================
--- linux-pm.orig/mm/memory_hotplug.c
+++ linux-pm/mm/memory_hotplug.c
@@ -1825,11 +1825,5 @@ void __ref remove_memory(int nid, u64 st
 
 	unlock_memory_hotplug();
 }
-#else
-int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
-{
-	return -EINVAL;
-}
-void remove_memory(int nid, u64 start, u64 size) {}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */

