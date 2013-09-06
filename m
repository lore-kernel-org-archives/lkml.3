Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3IFLHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:07:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1165 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3IFLHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:07:34 -0400
Message-ID: <5229B741.8000403@huawei.com>
Date: Fri, 6 Sep 2013 19:06:41 +0800
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
Subject: [PATCH 4/5] staging: olpc_dcon: remove unnecessary work pending test
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
 drivers/staging/olpc_dcon/olpc_dcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 193e1c6..0dfd528 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -381,7 +381,7 @@ static void dcon_set_source(struct dcon_priv *dcon, int arg)

 	dcon->pending_src = arg;

-	if ((dcon->curr_src != arg) && !work_pending(&dcon->switch_source))
+	if (dcon->curr_src != arg)
 		schedule_work(&dcon->switch_source);
 }

-- 
1.8.2.2



