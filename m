Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab3EXCmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 22:42:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18602 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3EXCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 22:42:29 -0400
X-AuditID: cbfee691-b7fef6d000002d62-7a-519ed394b5f8
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Jonathan Cameron'" <jic23@kernel.org>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] staging:iio:light:tsl2x7x: fix the error handling
 in tsl2x7x_probe()
Date: Fri, 24 May 2013 11:42:27 +0900
Message-id: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqvSUA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zI90pl+cFGkyYzGqxpJnb4kHTKiaL
	y7vmsFks2PiI0WLnuk52B1aPTas62Tz6tqxi9Fh67yijx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	B5sXMhdM5qt4v/8MUwPjNu4uRk4OCQETiSt3uxghbDGJC/fWs3UxcnEICSxjlPjybRs7TNHC
	3nvMEInpjBLTXq1gA0kICfxllFizjAXEZhPQlTi2fgsriC0i4C1xasovZhCbWaBIYte+HqA4
	B1A9t8Tq5iCQMKcAj8S6P51gJcICSRLbD54GO4JFQFWip30H2HheATuJ6V+XsUPYghI/Jt9j
	gRipJbF+53EmCFteYvOat8wg4yUE1CUe/dUFMUUEKiQ6FidCVIhI7HvxjhHkegmBS+wSC6e1
	skGsEpD4NvkQC0SrrMSmA8wQ30pKHFxxg2UCo8QsJItnIVk8C8niWUhWLGBkWcUomlqQXFCc
	lF5kqlecmFtcmpeul5yfu4kREpkTdzDeP2B9iDEZaP1EZinR5HxgZOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHm0jWRhPxJfzjOHzk0P/NI
	4LKSkCQX345W0+5XSx30X6xPdRcL6OqI/SnA9dZZ0fXuPiu1/cGXylN5vk48a/S1ZeKJ1Mrg
	vfzhxaWMghb9Ufu+rimY+0vHVLdjUaHzPr3sievCHb0bp+xvufmcU/TX1XNs30QevX8WuU96
	7pqp2pPPzyveo63EUpyRaKjFXFScCABTlQ4O4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd0pl+cFGvTOYrRY0sxt8aBpFZPF
	5V1z2CwWbHzEaLFzXSe7A6vHplWdbB59W1Yxeiy9d5TR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjIPNC5kLJvNVvN9/hqmBcRt3FyMnh4SAicTC3nvMELaY
	xIV769m6GLk4hASmM0pMe7WCDSQhJPCXUWLNMhYQm01AV+LY+i2sILaIgLfEqSm/wJqZBYok
	du3rAYpzANVzS6xuDgIJcwrwSKz70wlWIiyQJLH94GlGEJtFQFWip30H2HheATuJ6V+XsUPY
	ghI/Jt9jgRipJbF+53EmCFteYvOat8wg4yUE1CUe/dUFMUUEKiQ6FidCVIhI7HvxjnECo9As
	JINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvtn0jsYVzVYHGIU
	4GBU4uGdoTMvUIg1say4MvcQowQHs5IIb2EYUIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPz
	gSkpryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYfV4c23W0
	QfVhdJKSiuh7zuNXHRmrbwU6PSpZ8Ojuq8aU3Xm+H85afts2P3WyTLXDfcVz8ou5JmveyWT5
	xatWMe8Ii+M/243fHHn0zWWWmmlbTFHqaH7tlW6UcnSTaFOOlG5g426JS36S0ftSTFdeyWSv
	3L27vzBVck+wcIdP1Y41/Yk5H1cpsRRnJBpqMRcVJwIA8oouYz8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"

commit 3b813798aa7030f1beef638c75f8b0008f737a82 upstream

Fix to return -EINVAL in the i2c device found error handling
case instead of 0, as done elsewhere in this function.
And also correct the fail1 and fail2 lable to do the right thing.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/staging/iio/light/tsl2x7x_core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2x7x_core.c
b/drivers/staging/iio/light/tsl2x7x_core.c
index a58731e..2d40c03 100644
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -1869,6 +1869,7 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
 		dev_info(&chip->client->dev,
 				"%s: i2c device found does not match
expected id\n",
 				__func__);
+		ret = -EINVAL;
 		goto fail1;
 	}
 
@@ -1907,7 +1908,7 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
 		if (ret) {
 			dev_err(&clientp->dev,
 				"%s: irq request failed", __func__);
-			goto fail2;
+			goto fail1;
 		}
 	}
 
@@ -1920,17 +1921,17 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
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
1.7.9.5

