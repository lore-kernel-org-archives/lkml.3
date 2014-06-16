Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaFPJ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:28:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21887 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaFPJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:28:12 -0400
Message-ID: <539EB803.9070001@huawei.com>
Date: Mon, 16 Jun 2014 17:25:23 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 8/8] doc: update Documentation/sysctl/vm.txt
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the doc.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/sysctl/vm.txt |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index dd9d0e3..8008e53 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -20,6 +20,10 @@ Currently, these files are in /proc/sys/vm:
 
 - admin_reserve_kbytes
 - block_dump
+- cache_limit_mbytes
+- cache_limit_ratio
+- cache_reclaim_s
+- cache_reclaim_weight
 - compact_memory
 - dirty_background_bytes
 - dirty_background_ratio
@@ -97,6 +101,45 @@ information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
 
 ==============================================================
 
+cache_limit_mbytes
+
+This is used to limit page cache amount. The input unit is MB, value range
+is from 0 to totalram_pages. If this is set to 0, it will not limit page cache.
+When written to the file, cache_limit_ratio will be updated too.
+
+The default value is 0.
+
+==============================================================
+
+cache_limit_ratio
+
+This is used to limit page cache amount. The input unit is percent, value
+range is from 0 to 100. If this is set to 0, it will not limit page cache.
+When written to the file, cache_limit_mbytes will be updated too.
+
+The default value is 0.
+
+==============================================================
+
+cache_reclaim_s
+
+This is used to reclaim page cache in circles. The input unit is second,
+the minimum value is 0. If this is set to 0, it will disable the feature.
+
+The default value is 0.
+
+==============================================================
+
+cache_reclaim_weight
+
+This is used to speed up page cache reclaim. It depend on enabling
+cache_limit_mbytes/cache_limit_ratio or cache_reclaim_s. Value range is
+from 1(slow) to 100(fast).
+
+The default value is 1.
+
+==============================================================
+
 compact_memory
 
 Available only when CONFIG_COMPACTION is set. When 1 is written to the file,
-- 
1.6.0.2


