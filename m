Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaA1JCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:02:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaA1JCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:02:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,735,1384272000"; 
   d="scan'208";a="9461134"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] numa, mem-hotplug: Initialize numa_kernel_nodes in numa_clear_kernel_node_hotplug().
Date: Tue, 28 Jan 2014 17:05:15 +0800
Message-Id: <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 17:01:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 17:01:10,
	Serialize complete at 2014/01/28 17:01:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
was not initialized. So we need to initialize it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 arch/x86/mm/numa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 81b2750..00c9f09 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -569,6 +569,8 @@ static void __init numa_clear_kernel_node_hotplug(void)
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
+	nodes_clear(numa_kernel_nodes);
+
 	/* Mark all kernel nodes. */
 	for (i = 0; i < type->cnt; i++)
 		node_set(type->regions[i].nid, numa_kernel_nodes);
-- 
1.8.3.1

