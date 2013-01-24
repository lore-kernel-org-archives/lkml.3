Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3AXJjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:39:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3AXJjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:39:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,529,1355068800"; 
   d="scan'208";a="6640641"
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
Subject: [PATCH 1/2] cpu_hotplug: Remove __cpuinitdata declaration of __apicid_to_node[].
Date: Thu, 24 Jan 2013 17:38:06 +0800
Message-Id: <1359020287-11661-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1359020287-11661-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1359020287-11661-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:37:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:38:01,
	Serialize complete at 2013/01/24 17:38:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__apicid_to_node[] will be used by acpi_unmap_lsapic() when we do
node hotplug. So it is no longer an init data. Do not declare
__apicid_to_node[] as a __cpuinitdata, otherwise it will cause
section mismatch warning when compiling.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 9b31ed5..0624c85 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -56,7 +56,7 @@ early_param("numa", numa_setup);
 /*
  * apicid, cpu, node mappings
  */
-s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
+s16 __apicid_to_node[MAX_LOCAL_APIC] = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-- 
1.7.1

