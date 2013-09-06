Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab3IFLET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:04:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30939 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3IFLES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:04:18 -0400
Message-ID: <5229B68F.1000903@huawei.com>
Date: Fri, 6 Sep 2013 19:03:43 +0800
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
Subject: [PATCH 2/5] input: remove unnecessary work pending test
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
It has been tested in queue_work_on() already.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/input/touchscreen/cyttsp4_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index edcf799..b0ee865 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -1249,8 +1249,7 @@ static void cyttsp4_watchdog_timer(unsigned long handle)
 	if (!cd)
 		return;

-	if (!work_pending(&cd->watchdog_work))
-		schedule_work(&cd->watchdog_work);
+	schedule_work(&cd->watchdog_work);

 	return;
 }
-- 
1.8.2.2



