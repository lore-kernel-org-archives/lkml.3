Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3IJGgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:36:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30223 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3IJGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:36:12 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <mingo@redhat.com>, <wangyijing@huawei.com>, <guohanjun@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH] workqueue: remove redundant timer_stats_timer_set_start_info() call
Date: Tue, 10 Sep 2013 14:35:27 +0800
Message-ID: <1378794927-4396-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

There is a redundant call for timer_stats_timer_set_start_info(),
because it is the responsibility of the 'timer add' function:

add_timer_on()
|- timer_stats_timer_set_start_info()

add_timer()
|- mod_timer()
	|- __mod_timer()
		|- timer_stats_timer_set_start_info()

So the calling here is redundant, remove it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..51ca50e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1462,8 +1462,6 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 		return;
 	}
 
-	timer_stats_timer_set_start_info(&dwork->timer);
-
 	dwork->wq = wq;
 	dwork->cpu = cpu;
 	timer->expires = jiffies + delay;
-- 
1.8.2.1


