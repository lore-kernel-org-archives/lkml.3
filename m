Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3DOKos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:44:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3DOKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:44:47 -0400
Date: Mon, 15 Apr 2013 03:44:28 -0700
From: tip-bot for Tang Chen <tipbot@zytor.com>
Message-ID: <tip-587ff8c4eab1587044e69156f997e9d1d3b07709@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <1366019207-27818-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1366019207-27818-3-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/hotplug: Put kernel_physical_mapping_remove()
  declaration in CONFIG_MEMORY_HOTREMOVE
Git-Commit-ID: 587ff8c4eab1587044e69156f997e9d1d3b07709
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 15 Apr 2013 03:44:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  587ff8c4eab1587044e69156f997e9d1d3b07709
Gitweb:     http://git.kernel.org/tip/587ff8c4eab1587044e69156f997e9d1d3b07709
Author:     Tang Chen <tangchen@cn.fujitsu.com>
AuthorDate: Mon, 15 Apr 2013 17:46:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Apr 2013 12:03:24 +0200

x86/mm/hotplug: Put kernel_physical_mapping_remove() declaration in CONFIG_MEMORY_HOTREMOVE

kernel_physical_mapping_remove() is only called by
arch_remove_memory() in init_64.c, which is enclosed in
CONFIG_MEMORY_HOTREMOVE. So when we don't configure
CONFIG_MEMORY_HOTREMOVE, the compiler will give a warning:

	warning: ‘kernel_physical_mapping_remove’ defined but not used

So put kernel_physical_mapping_remove() in
CONFIG_MEMORY_HOTREMOVE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-mm@kvack.org
Cc: gregkh@linuxfoundation.org
Cc: yinghai@kernel.org
Cc: wency@cn.fujitsu.com
Cc: mgorman@suse.de
Cc: tj@kernel.org
Cc: liwanp@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1366019207-27818-3-git-send-email-tangchen@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
