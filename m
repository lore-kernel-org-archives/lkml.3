Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3AXXFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:05:32 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57450 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3AXXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:05:27 -0500
Date: Thu, 24 Jan 2013 15:05:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch -mm] memory-hotplug: export the function try_offline_node()
 fix
In-Reply-To: <1358855156-6126-3-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1301241501430.30690@chino.kir.corp.google.com>
References: <1358855156-6126-1-git-send-email-tangchen@cn.fujitsu.com> <1358855156-6126-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"memory-hotplug: export the function try_offline_node()" declares 
try_offline_node() for CONFIG_MEMORY_HOTPLUG, but this function is only 
defined for CONFIG_MEMORY_HOTREMOVE:

ERROR: "try_offline_node" [drivers/acpi/processor.ko] undefined!

Fix the build by definining it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 extensively trimmed the cc list of the email to only the maintainers
 from scripts/get_maintainer.pl.

 include/linux/memory_hotplug.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -193,7 +193,6 @@ extern void get_page_bootmem(unsigned long ingo, struct page *page,
 
 void lock_memory_hotplug(void);
 void unlock_memory_hotplug(void);
-extern void try_offline_node(int nid);
 
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
@@ -228,13 +227,13 @@ static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
 
 static inline void lock_memory_hotplug(void) {}
 static inline void unlock_memory_hotplug(void) {}
-static inline void try_offline_node(int nid) {}
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern void try_offline_node(int nid);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -242,6 +241,8 @@ static inline int is_mem_section_removable(unsigned long pfn,
 {
 	return 0;
 }
+
+static inline void try_offline_node(int nid) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
