Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3IFLFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:05:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64847 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3IFLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:05:36 -0400
Message-ID: <5229B6E5.70900@huawei.com>
Date: Fri, 6 Sep 2013 19:05:09 +0800
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
Subject: [PATCH 3/5] lib: remove unnecessary work pending test
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
Cc: Tejun Heo <tj@kernel.org>
---
 lib/debugobjects.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 37061ed..67e84c8 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -196,7 +196,7 @@ static void free_object(struct debug_obj *obj)
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = keventd_up() && !work_pending(&debug_obj_work);
+		sched = keventd_up();
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
-- 
1.8.2.2



