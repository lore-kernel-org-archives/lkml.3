Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab3BTGKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:10:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16928 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035Ab3BTGKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:10:41 -0500
X-AuditID: cbfee690-b7f066d00000169f-6d-512468dff41c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 03/11] mfd: aat2870: use devm_gpio_request_one() and
 devm_kzalloc()
Date: Wed, 20 Feb 2013 15:10:39 +0900
Message-id: <002801ce0f31$01a72b30$04f58190$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAABz+Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY937GSqBBi+3GVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MVV9/sRV08ldca9zA3sA4kaeLkZNDQsBE4uX5IywQtpjEhXvr
	2boYuTiEBJYxSmz7eosVpqjxxDwwW0hgOqPEu5kGEEWzmSTuvl3KCJJgE1CT+PLlMDuILSKg
	JdF97DzQJA4OZgEXiaPTRCB6bSW+r/0HNodTwE5i16PzYLawQKhE54eJYGNYBFQlHnyYzQRi
	8wLV77oxjQXCFpT4MfkemM0MNH79zuNMELa8xOY1b5lBVkkIqEs8+qsLcYGRxLVrTxghSkQk
	9r14xwhysoTAPHaJ65872SB2CUh8m3yIBaJXVmLTAWaIdyUlDq64wTKBUWIWks2zkGyehWTz
	LCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiasJOxjvHbA+xJgMtH4is5Rocj4w
	LvNK4g2NjU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVGC
	1+fP6a3n7PP9OCbPSN1lkH5T2ba14OWuuQEvlzTq/5ZS1NkmoZLvvu5XTvnfmj22+UKT/k+q
	fWCpVH2tdbHh28MuZfxGHg02lp8bVZXP7wmPaq2xudjUVBDe8e2ZcsW3KfdLPn5jbenx0ucV
	ZzfNi6ivK/TJvPaqKMY6umSt6JxKwYtLlFiKMxINtZiLihMB9Glt78ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO79DJVAg7s39Cwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqqvv9gKOvkrrjVuYG9g
	nMjTxcjJISFgItF4Yh4rhC0mceHeejYQW0hgOqPEu5kGXYxcQPZsJom7b5cygiTYBNQkvnw5
	zA5iiwhoSXQfOw/UwMHBLOAicXSaCESvrcT3tf/AZnIK2EnsenQezBYWCJXo/DARbAyLgKrE
	gw+zmUBsXqD6XTemsUDYghI/Jt8Ds5mBxq/feZwJwpaX2LzmLTPIKgkBdYlHf3UhLjCSuHbt
	CSNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgqH0mvYNxVYPFIUYBDkYlHt6GhcqBQqyJZcWVuYcYJTiYlUR4m51UAoV4UxIrq1KL8uOL
	SnNSiw8xJgM9OpFZSjQ5H5hQ8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2xJDU7NbUg
	tQhmCxMHp1QD43TFm9I3Iq2WZGxQOr87Sfvck9jlhSZbXrdsifRQceR5UzklLfJZ66uNQW5X
	G59zdHQ8UhIR48qbWvHNTW2mZ4m2eYiDSaJCpuj9X1vLOt4phbxbl/B78izp2KBTCpODzNdq
	i5Qo3eJed/rl1cTjzaulxBjiJ9RMEJWcWV+y+Y2zWlCARvdnJZbijERDLeai4kQAt5kxAB4D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() and devm_kzalloc() to make cleanup paths
more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/aat2870-core.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index f1beb49..dfdb0a2 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -367,12 +367,12 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 	int i, j;
 	int ret = 0;
 
-	aat2870 = kzalloc(sizeof(struct aat2870_data), GFP_KERNEL);
+	aat2870 = devm_kzalloc(&client->dev, sizeof(struct aat2870_data),
+				GFP_KERNEL);
 	if (!aat2870) {
 		dev_err(&client->dev,
 			"Failed to allocate memory for aat2870\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	aat2870->dev = &client->dev;
@@ -400,12 +400,12 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 		aat2870->init(aat2870);
 
 	if (aat2870->en_pin >= 0) {
-		ret = gpio_request_one(aat2870->en_pin, GPIOF_OUT_INIT_HIGH,
-				       "aat2870-en");
+		ret = devm_gpio_request_one(&client->dev, aat2870->en_pin,
+					GPIOF_OUT_INIT_HIGH, "aat2870-en");
 		if (ret < 0) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d\n", aat2870->en_pin);
-			goto out_kfree;
+			return ret;
 		}
 	}
 
@@ -436,11 +436,6 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 
 out_disable:
 	aat2870_disable(aat2870);
-	if (aat2870->en_pin >= 0)
-		gpio_free(aat2870->en_pin);
-out_kfree:
-	kfree(aat2870);
-out:
 	return ret;
 }
 
@@ -452,11 +447,8 @@ static int aat2870_i2c_remove(struct i2c_client *client)
 
 	mfd_remove_devices(aat2870->dev);
 	aat2870_disable(aat2870);
-	if (aat2870->en_pin >= 0)
-		gpio_free(aat2870->en_pin);
 	if (aat2870->uninit)
 		aat2870->uninit(aat2870);
-	kfree(aat2870);
 
 	return 0;
 }
-- 
1.7.2.5


