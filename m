Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3CNITi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:19:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43643 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3CNITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:19:36 -0400
X-AuditID: cbfee690-b7f656d0000007e3-4a-51418817f987
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 16/30] rtc: rtc-max6900: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:19:35 +0900
Message-id: <009301ce208c$a99a3910$fcceab30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAT+UQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ13xDsdAgzuLlSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuP32CXPBX46Ku2ub2BsY97J3MXJySAiYSNy49YwFwhaTuHBvPVsXIxeHkMAyRonu
	QweZYYomr//DDJGYDpRY8x6q6hejxNxLv8Cq2ATUJL58OQw0loNDREBfoq1FA6SGWaCXUeJM
	726wuJCArcT1/3YgJqeAncSG9WIgncIC7hI31m5iBQmzCKhKbO3QAAnzAhWfPHWRHcIWlPgx
	+R7YncwCWhLrdx5ngrDlJTavecsM0iohoC7x6K8uSFhEwEji3swbbBAlIhL7XrxjBDlGQuAW
	u8TcPw1gCRYBAYlvkw+xQPTKSmw6APWtpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGCFROmEH470D1ocYk4HWT2SWEk3OB0Z5Xkm8obGZkYWp
	iamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYJz7hm73lfk9028qn
	V4MnGh69M+dFU+u0PZc0194uSUztuWPlp75Id0rCmvVqfruvnlALi9DSmfh2/6qcyyeCpons
	nP9WP4i1NF+Ab2+iG2NO4saz3f8ZLH0L5rOZSbDzvbij/jlZjmFOeP7f7TeWXGDa83u53vT5
	6c0rX1+aLJsbGpqS3aviosRSnJFoqMVcVJwIAO3um+voAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3xDsdAg4bHshZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZtx++4S54C9Hxd21TewNjHvZuxg5OSQETCQm
	r//DDGGLSVy4t56ti5GLQ0hgOqNE95r3UM4vRom5l36BVbEJqEl8+XIYqJuDQ0RAX6KtRQOk
	hlmgl1HiTO9usLiQgK3E9f92ICangJ3EhvViIJ3CAu4SN9ZuYgUJswioSmzt0AAJ8wIVnzx1
	kR3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKERQSMJO7NvMEGUSIise/F
	O8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAU8k97B
	uKrB4hCjAAejEg9vhKhjoBBrYllxZe4hRgkOZiURXk8voBBvSmJlVWpRfnxRaU5q8SHGZKA/
	JzJLiSbnA9NTXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	tgWwRKb/9JnCtWM/j4Wt94kzZhnZ5coam17mMMm8vWWut9CCu3fiZ3XBEsXpx+3qKgwYnUxr
	rE6XLsv8LGq6m1mwjaP74mQm/Qr7j22xmpdnXgwQed705HZj1p+T8tP4c43v+t47dSZeIG1Z
	wIK/N1XkUg+cr15y38jPrEWOJfTFIjYJ0UNKLMUZiYZazEXFiQCRxdjFRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max6900.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
index a00e332..8669d6d 100644
--- a/drivers/rtc/rtc-max6900.c
+++ b/drivers/rtc/rtc-max6900.c
@@ -214,11 +214,6 @@ static int max6900_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 static int max6900_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
@@ -237,8 +232,8 @@ max6900_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(max6900_driver.driver.name,
-				  &client->dev, &max6900_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, max6900_driver.driver.name,
+					&max6900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-- 
1.7.2.5


