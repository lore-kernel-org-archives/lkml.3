Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3IFLEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:04:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48443 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IFLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:04:43 -0400
Message-ID: <5229B64A.1030304@huawei.com>
Date: Fri, 6 Sep 2013 19:02:34 +0800
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
Subject: [PATCH 1/5] iio: adc: remove unnecessary work pending test
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
 drivers/staging/iio/adc/ad7606_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7606_core.c b/drivers/staging/iio/adc/ad7606_core.c
index 72868ce..c6f99069 100644
--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -424,10 +424,9 @@ static irqreturn_t ad7606_interrupt(int irq, void *dev_id)
 	struct iio_dev *indio_dev = dev_id;
 	struct ad7606_state *st = iio_priv(indio_dev);

-	if (iio_buffer_enabled(indio_dev)) {
-		if (!work_pending(&st->poll_work))
-			schedule_work(&st->poll_work);
-	} else {
+	if (iio_buffer_enabled(indio_dev))
+		schedule_work(&st->poll_work);
+	else {
 		st->done = true;
 		wake_up_interruptible(&st->wq_data_avail);
 	}
-- 
1.8.2.2



