Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab3BTJ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:27:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20083 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab3BTJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:27:32 -0500
X-AuditID: cbfee68f-b7f656d000000d78-cf-512496f9fc48
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 1/9] mfd: 88pm860x: drop devm_kfree of devm_kzalloc'd data
Date: Wed, 20 Feb 2013 18:27:21 +0900
Message-id: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zQ92f01QCDX6t1La4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZL2bdYCo4z1XxbvMptgbGwxxdjJwcEgImEvc+X2SFsMUkLtxb
	z9bFyMUhJLCMUWL1/ZXMXYwcYEVrDpVCxKczStyfcRuqaDaTxONzE8G62QTUJL58OcwOYosI
	aEl0HzvPBtLMLOAicXSaCEhYWMBX4mXvcbASFgFViTMNi8FaeQVsJaZM2skGYQtK/Jh8jwXE
	ZgYas37ncSYIW15i85q3UPeoSzz6qwuxSU/i5c/3UOUiEvtevGMEOU1CoJldYteyB2wQuwQk
	vk0+xALRKyux6QAzxL+SEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525ihMRJ/w7GuwesDzEmA62fyCwlmpwPjLO8knhDY2MTMxNTE3NLU3NT0oSV
	xHnlL8kECgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBMsp37neXgDwHFr74V344HT97Mdeld
	8ZGG918jNVccfJj6aprAudBSVY/bTY+tWCwstov0TdOo/F5qXHa00U9NpjdmudOdKyKB788t
	T6u8qzrZM67W/fnpO5PsVj/YYy3ZnPPmTJZdV8TOmveW9neSo9bplH/KTXvVfSrPKUvW/TXX
	3X6OpiYlluKMREMt5qLiRAAl3YSpqQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd2f01QCDeZ+U7W4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGS9m3WAqOM9V8W7zKbYG
	xsMcXYwcHBICJhJrDpV2MXICmWISF+6tZ+ti5OIQEpjOKHF/xm0oZzaTxONzE1lBqtgE1CS+
	fDnMDmKLCGhJdB87zwYyiFnAReLoNBGQsLCAr8TL3uNgJSwCqhJnGhaDtfIK2EpMmbSTDcIW
	lPgx+R4LiM0MNGb9zuNMELa8xOY1b5khblOXePRXF2KTnsTLn++hykUk9r14xziBUWAWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER+Ez6R2MqxosDjEKcDAq
	8fA2LFQOFGJNLCuuzD3EKMHBrCTC+7NDJVCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84EJ
	Iq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1MAo+rmhJv9+z
	O3ydlDlnj1PpVPlSgU5mvx9B6Ynscma3jkVsT3quVLOMdVvE5pb8A0/nr8k/Lta2RUD9wlfL
	/cz5dbkl69sWqm7OZ4sy1Hs9RV7/0Lznsy6+X278oMJbVNDSviVt2eEH4nLTIufpXHTNbPxy
	5mr6h203XRN5lp8tPM0uOdmuU4mlOCPRUIu5qDgRAHsNdPYGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kfree() allocates memory that is released when a driver detaches.
Thus, there is no reason to explicitly call devm_kfree() in probe or remove
functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/mfd/88pm860x-core.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 893fc1b..31ca555 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1144,17 +1144,15 @@ static int pm860x_probe(struct i2c_client *client,
 			return -ENOMEM;
 		ret = pm860x_dt_init(node, &client->dev, pdata);
 		if (ret)
-			goto err;
+			return ret;
 	} else if (!pdata) {
 		pr_info("No platform data in %s!\n", __func__);
 		return -EINVAL;
 	}
 
 	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
-	if (chip == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (chip == NULL)
+		return -ENOMEM;
 
 	chip->id = verify_addr(client);
 	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
@@ -1194,10 +1192,6 @@ static int pm860x_probe(struct i2c_client *client,
 
 	pm860x_device_init(chip, pdata);
 	return 0;
-err:
-	if (node)
-		devm_kfree(&client->dev, pdata);
-	return ret;
 }
 
 static int pm860x_remove(struct i2c_client *client)
-- 
1.7.2.5


