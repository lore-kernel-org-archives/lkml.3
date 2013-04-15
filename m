Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3DOJoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:44:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20897 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3DOJoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:44:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,475,1363104000"; 
   d="scan'208";a="7057093"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, akpm@linux-foundation.org,
        wency@cn.fujitsu.com, mgorman@suse.de, tj@kernel.org,
        liwanp@linux.vnet.ibm.com
Cc: tangchen@cn.fujitsu.com, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mem-hotplug: Put kernel_physical_mapping_remove() declaration in CONFIG_MEMORY_HOTREMOVE.
Date: Mon, 15 Apr 2013 17:46:46 +0800
Message-Id: <1366019207-27818-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:35
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_physical_mapping_remove() is only called by arch_remove_memory() in
init_64.c, which is enclosed in CONFIG_MEMORY_HOTREMOVE. So when we don't
configure CONFIG_MEMORY_HOTREMOVE, the compiler will give a warning:

	warning: ‘kernel_physical_mapping_remove’ defined but not used

So put kernel_physical_mapping_remove() in CONFIG_MEMORY_HOTREMOVE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..dafdeb2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1019,6 +1019,7 @@ void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
 	remove_pagetable(start, end, false);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1028,7 +1029,6 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true);
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
-- 
1.7.1

