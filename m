Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3CNINJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:13:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14439 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab3CNING (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:13:06 -0400
X-AuditID: cbfee68e-b7f946d000001e37-41-514186916df6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 06/30] rtc: rtc-ds1672: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:13:04 +0900
Message-id: <008901ce208b$c0e8fa80$42baef80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAFOdw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY92JbY6BBu1POC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG1sPrmQuWcVbcPn6XrYHxEnsXIyeHhICJxNGbB5khbDGJC/fW
	s3UxcnEICSxjlHj+ZQ8LTNGRrzfYIRKLGCVWnp3MBOHMZpJourAKrJ1NQE3iy5fDQFUcHCIC
	+hJtLRogNcwCvYwSZ3p3g8WFBGwlrv+3AzE5BewkNqwXA+kUFnCT2P9pLiuIzSKgKrF3xgRG
	EJsXqHr1wl3sELagxI/J98DuYRbQkli/8zgThC0vsXnNW2aQkRIC6hKP/uqChEUEjCTmLprG
	DFEiIrHvxTtGkGskBJaxSzSvnAO1S0Di2+RDLBC9shKbDkDDQVLi4IobLBMYJWYh2TwLyeZZ
	SDbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQuOrbwXjzgPUhxmSg9ROZpUST
	84FxmVcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	RuXAf0uf+LR7dW6Nuj4h/cX5M6d8u+3jLFaU3/dXFTFR4/o4889Cm0X8Kp9U/u9Y4euf0vTU
	IaGoImmaSXdnrljic1cbju9fhdVZOzPinuZt5Dn2R9VNNehAUvaj7jj3RTrS4nN/fvc9qJRc
	edNsmdNU4+IfB/ctXmR2577f0vkCntJzvs46ocRSnJFoqMVcVJwIANVoIInBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7ENsdAg+OXWSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtbD65kLlnFW3D5+l62B
	8RJ7FyMnh4SAicSRrzegbDGJC/fWs3UxcnEICSxilFh5djIThDObSaLpwipmkCo2ATWJL18O
	A3VwcIgI6Eu0tWiA1DAL9DJKnOndDRYXErCVuP7fDsTkFLCT2LBeDKRTWMBNYv+nuawgNouA
	qsTeGRMYQWxeoOrVC3exQ9iCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZZKSEgLrEo7+6IGER
	ASOJuYumMUOUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7N
	S9dLzs/dxAiO2mfSOxhXNVgcYhTgYFTi4Y0QdQwUYk0sK67MPcQowcGsJMLr6QUU4k1JrKxK
	LcqPLyrNSS0+xJgM9OhEZinR5HxgQskriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBkZV989VlydtYa8/dIDZRd/q3kM/X8vrP4U29IUYGq/NVzTLediTbaO5
	T+SMu7vxseDzS+bxRJv8u7Vj7aHMrXl3p/qVrTm10eFA9IoblT3b7/q1OFzzOSrJM3WRaUvx
	Pi1Jv29P3/4OXbmtwmvmz9/r5wit0u0XCVVl8f51mmnxa6EHGx+uPjBTiaU4I9FQi7moOBEA
	u8r+WR4DAAA=
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
 drivers/rtc/rtc-ds1672.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index 45d65c0..3fc2a47 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -155,11 +155,6 @@ static const struct rtc_class_ops ds1672_rtc_ops = {
 
 static int ds1672_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
@@ -177,7 +172,7 @@ static int ds1672_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(ds1672_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, ds1672_driver.driver.name,
 				  &ds1672_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
@@ -202,7 +197,6 @@ static int ds1672_probe(struct i2c_client *client,
 	return 0;
 
  exit_devreg:
-	rtc_device_unregister(rtc);
 	return err;
 }
 
-- 
1.7.2.5


