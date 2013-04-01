Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3DAJsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:48:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20501 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3DAJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:48:22 -0400
X-AuditID: cbfee68d-b7f786d000005188-d9-515957e57b28
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 19/27] rtc: rtc-pcf8563: use devm_*() functions
Date: Mon, 01 Apr 2013 18:48:21 +0900
Message-id: <001e01ce2ebe$0ba06cd0$22e14670$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAANc3A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ92n4ZGBBn0dWhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlnL40kb1gMm/ForcL2RsYH3N1MXJwSAiYSPz5rtvFyAlkiklcuLeerYuRi0NIYBmj
	xLkT75ggEiYSN648YwexhQSmM0o0bdKEKPrFKDF/WysbSIJNQE3iy5fD7CBDRQT0JdpaNEBq
	mAV6GSXO9O6GaraV+HH2OzOIzSlgJ/Fm4TxGkHphAXuJ89fLQcIsAqoS6//dASvnBSpfv2Q+
	I4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIX5Rl3j0F+wXEQEjietXtzBDlIhI7HvxjhHi
	lXvsEh0flSFWCUh8m3yIBaJVVmLTAWaIEkmJgytusExglJiFZPEsJItnIVk8C8mGBYwsqxhF
	UwuSC4qT0osM9YoTc4tL89L1kvNzNzFCYrR3B+PtA9aHGJOB1k9klhJNzgfGeF5JvKGxmZGF
	qYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOelv/HxdX8+Q/lg
	NqPYbjejggeT02Oqf9wVflJgcGPfxqYXrz70+s+ZdPvZ+RlzXs14fSA1IHv33i27p/FyvWF6
	tNLbZGFCexDbTJmCb0tX7JOVXcV9eJfilH+Gu9jqT7XMvns3sYFtzqHHq8tr9fRrmO+uSI7r
	9NjHr6nPI30qcp7Th00Kf8yVWIozEg21mIuKEwFb0MX75wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2n4ZGBBm2NahZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpy+NJG9YDJvxaK3C9kbGB9zdTFyckgImEjc
	uPKMHcIWk7hwbz0biC0kMJ1RommTZhcjF5D9i1Fi/rZWsASbgJrEly+HgRo4OEQE9CXaWjRA
	apgFehklzvTuZodotpX4cfY7M4jNKWAn8WbhPEaQemEBe4nz18tBwiwCqhLr/90BK+cFKl+/
	ZD4jhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBxkgIqEs8+qsLEhYRMJK4fnULM0SJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAk8Ex6
	B+OqBotDjAIcjEo8vBEXIgKFWBPLiitzDzFKcDArifD6fAMK8aYkVlalFuXHF5XmpBYfYkwG
	enQis5Rocj4wQeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+PySdtZb/NOzvpo7PuX8VyU4NpUKd7LLZ53N327sMRYK2fztmCfnfxNqYuFYhZw5D9fsPmH
	At/jnSmRJYskpJhXnvOLsrhuxf23gIH/72mTRJVz/X9uCLg88TXv/VBs4fRx6rQHC9RmP5oQ
	+mmWREXAs0ORXF2flkasYTNYdFD5uar19efRzxYosRRnJBpqMRcVJwIA/umQY0YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf8563.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index f7daf18..97b354a 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -245,14 +245,13 @@ static int pcf8563_probe(struct i2c_client *client,
 {
 	struct pcf8563 *pcf8563;
 
-	int err = 0;
-
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL);
+	pcf8563 = devm_kzalloc(&client->dev, sizeof(struct pcf8563),
+				GFP_KERNEL);
 	if (!pcf8563)
 		return -ENOMEM;
 
@@ -260,31 +259,18 @@ static int pcf8563_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, pcf8563);
 
-	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name,
-				&client->dev, &pcf8563_rtc_ops, THIS_MODULE);
+	pcf8563->rtc = devm_rtc_device_register(&client->dev,
+				pcf8563_driver.driver.name,
+				&pcf8563_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8563->rtc)) {
-		err = PTR_ERR(pcf8563->rtc);
-		goto exit_kfree;
-	}
+	if (IS_ERR(pcf8563->rtc))
+		return PTR_ERR(pcf8563->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(pcf8563);
-
-	return err;
 }
 
 static int pcf8563_remove(struct i2c_client *client)
 {
-	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
-
-	if (pcf8563->rtc)
-		rtc_device_unregister(pcf8563->rtc);
-
-	kfree(pcf8563);
-
 	return 0;
 }
 
-- 
1.7.2.5


