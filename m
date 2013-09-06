Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3IFLIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:08:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1410 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3IFLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:08:12 -0400
Message-ID: <5229B779.4000704@huawei.com>
Date: Fri, 6 Sep 2013 19:07:37 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Thomas Gleixner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadia Derbey <Nadia.Derbey@bull.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] ipc: remove unnecessary work pending test
References: <5229B601.9090109@huawei.com>
In-Reply-To: <5229B601.9090109@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary work pending test before calling schedule_work().
It has been tested in queue_work_on() already. No functional changed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Tejun Heo <tj@kernel.org>
---
 ipc/util.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 4704223..f9105ed 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -67,10 +67,8 @@ static int ipc_memory_callback(struct notifier_block *self,
 		 * In order not to keep the lock on the hotplug memory chain
 		 * for too long, queue a work item that will, when waken up,
 		 * activate the ipcns notification chain.
-		 * No need to keep several ipc work items on the queue.
 		 */
-		if (!work_pending(&ipc_memory_wq))
-			schedule_work(&ipc_memory_wq);
+		schedule_work(&ipc_memory_wq);
 		break;
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
-- 
1.8.2.2



