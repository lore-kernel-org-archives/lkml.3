Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3ARHzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:55:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46461 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab3ARHzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:55:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,490,1355068800"; 
   d="scan'208";a="6611057"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Cc: mhocko@suse.cz, mel@csn.ul.ie, minchan@kernel.org, aquini@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, laijs@cn.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] memory-hotplug: mm/Kconfig: move auto selects from MEMORY_HOTPLUG to MEMORY_HOTREMOVE as needed
Date: Fri, 18 Jan 2013 15:54:36 +0800
Message-Id: <1358495676-4488-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 15:54:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 15:54:58,
	Serialize complete at 2013/01/18 15:54:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have 2 config options called MEMORY_HOTPLUG and MEMORY_HOTREMOVE
used for memory hot-add and hot-remove separately, and codes in function
register_page_bootmem_info_node() are only used for collecting infomation
for hot-remove(commit 04753278), so move it to MEMORY_HOTREMOVE.

Besides page_isolation.c selected by MEMORY_ISOLATION under MEMORY_HOTPLUG
is also such case, move it too.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index f8c5799..a96c010 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -172,8 +172,6 @@ config HAVE_BOOTMEM_INFO_NODE
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
-	select MEMORY_ISOLATION
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
@@ -184,6 +182,8 @@ config MEMORY_HOTPLUG_SPARSE
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
+	select MEMORY_ISOLATION
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
-- 
1.7.1

