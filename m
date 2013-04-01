Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3DAJpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:45:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20187 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:45:49 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-68-5159574c60c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 11/27] rtc: rtc-m41t80: use devm_*() functions
Date: Mon, 01 Apr 2013 18:45:47 +0900
Message-id: <001601ce2ebd$b00ea710$102bf530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAHykg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY12f8MhAg72LxSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOLvhLkvBB96Kp3+amBoYN3B3MXJySAiYSNxa3ckIYYtJXLi3nq2LkYtDSGAZo8S2
	tcuYYIpuz3zHDpFYxCgxof0xlPOLUeLjk1awKjYBNYkvXw4DJTg4RAT0JdpaNEBqmAV6GSXO
	9O5mB6kRErCV+HH2OzOIzSlgJ/Fm4TxGkHphIPv4CgkQk0VAVaLnCy+IyQtUffa1N0gxr4Cg
	xI/J91hAbGYBLYn1O48zQdjyEpvXvGUGKZcQUJd49FcXJCwiYCRx8tVFqBIRiX0v3jGCHCMh
	cI9d4sTuxawgCRYBAYlvkw+xQPTKSmw6wAzxraTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaW
	VYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxghUdq/g/HuAetDjMlA6ycyS4km5wOjPK8k3tDY
	zMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNInqhuuSafe
	dVM/pmTn3fj/wpOVbD7xtWdcyqeINJ29r5ko7jX5sPBdtv/vXOekpe/et9t5yS4+nztR7ycu
	Mthf7Fpy6Gilxc+Cib+nVF6Uc1K8c58zd8nb13MPiX92nbTz8os3c+4+LLnD/vtM2bQ1vFb1
	WUGTK22UrNfkeW9nZlxpOkEsTFKJpTgj0VCLuag4EQB8uKRu6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAV2f8MhAgws/BC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDi74S5LwQfeiqd/mpgaGDdwdzFyckgImEjc
	nvmOHcIWk7hwbz1bFyMXh5DAIkaJCe2P2SGcX4wSH5+0MoFUsQmoSXz5chgowcEhIqAv0dai
	AVLDLNDLKHGmdzfYJCEBW4kfZ78zg9icAnYSbxbOYwSpFwayj6+QADFZBFQler7wgpi8QNVn
	X3uDFPMKCEr8mHyPBcRmFtCSWL/zOBOELS+xec1bZpByCQF1iUd/dUHCIgJGEidfXYQqEZHY
	9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcAp5J
	72Bc1WBxiFGAg1GJhzfiQkSgEGtiWXFl7iFGCQ5mJRFen29AId6UxMqq1KL8+KLSnNTiQ4zJ
	QG9OZJYSTc4Hpqe8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCU
	amBkv/lUbzZ3/mKVlvCuut08hyoLAvT/+oUcSo3p3R0ze4PJbGGD5gKZtlIm1vpvTPJtppnH
	VM/fFJuZquhYfibjw66fy78onLJRSJ1gGpP4a8bvKOsvi8SlF3ed1mT68lVzkeGLm2+S8r8c
	2fVr53TphX+zDGT+lnxaJlw9fblbzUIXcS+xBUlKLMUZiYZazEXFiQDo7NRTRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m41t80.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index b885bcd..89674b5 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -637,7 +637,8 @@ static int m41t80_probe(struct i2c_client *client,
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
-	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
+	clientdata = devm_kzalloc(&client->dev, sizeof(*clientdata),
+				GFP_KERNEL);
 	if (!clientdata) {
 		rc = -ENOMEM;
 		goto exit;
@@ -646,8 +647,8 @@ static int m41t80_probe(struct i2c_client *client,
 	clientdata->features = id->driver_data;
 	i2c_set_clientdata(client, clientdata);
 
-	rtc = rtc_device_register(client->name, &client->dev,
-				  &m41t80_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, client->name,
+					&m41t80_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		rc = PTR_ERR(rtc);
 		rtc = NULL;
@@ -718,26 +719,19 @@ ht_err:
 	goto exit;
 
 exit:
-	if (rtc)
-		rtc_device_unregister(rtc);
-	kfree(clientdata);
 	return rc;
 }
 
 static int m41t80_remove(struct i2c_client *client)
 {
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	struct rtc_device *rtc = clientdata->rtc;
 
-#ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
 		misc_deregister(&wdt_dev);
 		unregister_reboot_notifier(&wdt_notifier);
 	}
 #endif
-	if (rtc)
-		rtc_device_unregister(rtc);
-	kfree(clientdata);
 
 	return 0;
 }
-- 
1.7.2.5


