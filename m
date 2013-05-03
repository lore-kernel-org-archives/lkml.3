Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125Ab3ECABu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:01:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54807 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762058Ab3ECABX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:23 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 07/31] mm: Add Dynamic NUMA Kconfig.
Date: Thu,  2 May 2013 17:00:39 -0700
Message-Id: <1367539263-19999-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B8DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to add some functionality for use by Dynamic NUMA to pieces of
mm/, so provide the Kconfig prior to adding actual Dynamic NUMA
functionality. For details on Dynamic NUMA, see te later patch (which
adds baseline functionality):

 "mm: add memlayout & dnuma to track pfn->nid & transplant pages between nodes"
---
 mm/Kconfig | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e742d06..bfbe300 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -169,6 +169,30 @@ config MOVABLE_NODE
 config HAVE_BOOTMEM_INFO_NODE
 	def_bool n
 
+config DYNAMIC_NUMA
+	bool "Dynamic Numa: Allow NUMA layout to change after boot time"
+	depends on NUMA
+	depends on !DISCONTIGMEM
+	depends on MEMORY_HOTPLUG # locking + mem_online_node().
+	help
+	 Dynamic Numa (DNUMA) allows the movement of pages between NUMA nodes at
+	 run time.
+
+	 Typically, this is used on systems running under a hypervisor which
+	 may move the running VM based on the hypervisors needs. On such a
+	 system, this config option enables Linux to update it's knowledge of
+	 the memory layout.
+
+	 If the feature is not used but is enabled, there is a very small
+	 amount of overhead (an additional pageflag check) is added to all page frees.
+
+	 This is only useful if you enable some of the additional options to
+	 allow modifications of the numa memory layout (either through hypervisor events
+	 or a userspace interface).
+
+	 Choose Y if you have are running linux under a hypervisor that uses
+	 this feature, otherwise choose N if unsure.
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
-- 
1.8.2.2

