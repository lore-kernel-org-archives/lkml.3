Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaFPJ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:27:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20651 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaFPJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:47 -0400
Message-ID: <539EB7FE.1070009@huawei.com>
Date: Mon, 16 Jun 2014 17:25:18 +0800
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
Subject: [PATCH 7/8] mm: implement page cache reclaim speed
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter vm_cache_reclaim_weight means every time we expect to
reclaim SWAP_CLUSTER_MAX * vm_cache_reclaim_weight pages.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d179be6..23b808a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3430,7 +3430,7 @@ static unsigned long __shrink_page_cache(gfp_t mask)
 	struct scan_control sc = {
 		.gfp_mask = (mask = memalloc_noio_flags(mask)),
 		.may_writepage = !laptop_mode,
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX * vm_cache_reclaim_weight,
 		.may_unmap = 1,
 		.may_swap = 1,
 		.order = 0,
-- 
1.6.0.2


