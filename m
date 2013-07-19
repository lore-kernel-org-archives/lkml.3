Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab3GSIII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:08:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759742Ab3GSIA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:00:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947446"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 21/21] doc, page_alloc, acpi, mem-hotplug: Add doc for movablecore=acpi boot option.
Date: Fri, 19 Jul 2013 15:59:34 +0800
Message-Id: <1374220774-29974-22-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:50,
	Serialize complete at 2013/07/19 15:58:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we modify movablecore boot option to support
"movablecore=acpi", this patch adds doc for it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2fe6e76..7aa1099 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1714,6 +1714,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablecore=acpi	[KNL,X86] The SRAT (System Resource Affinity
+			Table) in ACPI provides the NUMA info of the system.
+			And also, there is a Hotpluggable field in the memory
+			affinity of the table specifying which memory is
+			hotpluggable. This option enables the kernel to arrange
+			hotpluggable memory in SRAT as ZONE_MOVABLE.
+			NOTE: Any node which the kernel resides in will
+			      always be un-hotpluggable so that the kernel
+			      will always have enough memory to boot.
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
-- 
1.7.1

