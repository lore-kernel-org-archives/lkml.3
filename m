Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3FDOI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3FDOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 39/70] staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()
Date: Tue,  4 Jun 2013 15:06:55 +0100
Message-Id: <1370354846-14213-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3b813798aa7030f1beef638c75f8b0008f737a82 upstream.

Fix to return -EINVAL in the i2c device found error handling
case instead of 0, as done elsewhere in this function.
And also correct the fail1 and fail2 lable to do the right thing.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/light/tsl2x7x_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index c3b05a1..0c656ca 100755
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -1924,6 +1924,7 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 		dev_info(&chip->client->dev,
 				"%s: i2c device found does not match expected id\n",
 				__func__);
+		ret = -EINVAL;
 		goto fail1;
 	}
 
@@ -1962,7 +1963,7 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 		if (ret) {
 			dev_err(&clientp->dev,
 				"%s: irq request failed", __func__);
-			goto fail2;
+			goto fail1;
 		}
 	}
 
@@ -1975,17 +1976,17 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 	if (ret) {
 		dev_err(&clientp->dev,
 			"%s: iio registration failed\n", __func__);
-		goto fail1;
+		goto fail2;
 	}
 
 	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
 
 	return 0;
 
-fail1:
+fail2:
 	if (clientp->irq)
 		free_irq(clientp->irq, indio_dev);
-fail2:
+fail1:
 	iio_device_free(indio_dev);
 
 	return ret;
-- 
1.8.1.2

