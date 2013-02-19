Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab3BSNC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:02:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab3BSNC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:02:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,695,1355068800"; 
   d="scan'208";a="6730210"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 2/2] acpi, movablemem_map: Set numa_nodes_hotplug nodemask when using SRAT info.
Date: Tue, 19 Feb 2013 21:01:44 +0800
Message-Id: <1361278904-8690-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1361278904-8690-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1361278904-8690-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:44,
	Serialize complete at 2013/02/19 21:01:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should also set movablemem_map.numa_nodes_hotplug nodemask when we
insert a hot-pluggable range in SRAT into movablemem_map.map[].

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index b20b5b7..62ba97b 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -164,6 +164,12 @@ handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 	 */
 	if (hotpluggable && movablemem_map.acpi) {
 		insert_movablemem_map(start_pfn, end_pfn);
+
+		/*
+		 * numa_nodes_hotplug nodemask represents which nodes are put
+		 * into movablemem_map.map[].
+		 */
+		node_set(node, movablemem_map.numa_nodes_hotplug);
 		goto out;
 	}
 
-- 
1.7.1

