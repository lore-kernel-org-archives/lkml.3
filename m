Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3AXJjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:39:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31932 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3AXJjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:39:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,529,1355068800"; 
   d="scan'208";a="6640643"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, tglx@linutronix.de, minchan.kim@gmail.com,
        rientjes@google.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au, guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH 2/2] cpu-hotplug,memory-hotplug: Remove __cpuinit declaration of numa_clear_node().
Date: Thu, 24 Jan 2013 17:38:07 +0800
Message-Id: <1359020287-11661-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1359020287-11661-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1359020287-11661-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:37:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:38:02,
	Serialize complete at 2013/01/24 17:38:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_clear_node() will be used by check_and_unmap_cpu_on_node()
when we do node hotplug. So it is no longer a __cpuinit function.
Do not declare it as a __cpuinit function, otherwise it will cause
section mismatch warning when compiling.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 0624c85..6864b08 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -100,7 +100,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 	set_cpu_numa_node(cpu, node);
 }
 
-void __cpuinit numa_clear_node(int cpu)
+void numa_clear_node(int cpu)
 {
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
-- 
1.7.1

