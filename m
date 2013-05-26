Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3EZF7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 01:59:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59847 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3EZF65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 01:58:57 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for 32bit
Date: Sun, 26 May 2013 13:58:38 +0800
Message-Id: <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052605-2674-0000-0000-0000091CF833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since 
it was born, this patch disable memory hotremove when 32bit at compile 
time.

Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e742d06..ada9569 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -184,6 +184,7 @@ config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select MEMORY_ISOLATION
 	select HAVE_BOOTMEM_INFO_NODE if X86_64
+	depends on 64BIT
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
-- 
1.8.1.2

