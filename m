Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab3LIJy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:54:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:10340 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3LIJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:54:26 -0500
Message-ID: <52A592DE.7010302@huawei.com>
Date: Mon, 9 Dec 2013 17:52:30 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        <rientjes@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm: add show num_poisoned_pages when oom
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show num_poisoned_pages when oom, it is helpful to find the reason.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
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
+	printk("%lu pages poisoned\n", atomic_long_read(&num_poisoned_pages));
+#endif
 }
-- 
1.7.1

