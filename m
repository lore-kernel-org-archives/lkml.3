Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3LJBvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:51:16 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40804 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3LJBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:51:15 -0500
Message-ID: <52A670AC.6090504@huawei.com>
Date: Tue, 10 Dec 2013 09:38:52 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH V2] mm: add show num_poisoned_pages when oom
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show num_poisoned_pages when oom, it is a little helpful to find the reason.
Also it will be emitted anytime show_mem() is called.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
---
 lib/show_mem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/show_mem.c b/lib/show_mem.c
index 5847a49..1cbdcd8 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -46,4 +46,7 @@ void show_mem(unsigned int filter)
 	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+#endif
 }
-- 
1.7.1


