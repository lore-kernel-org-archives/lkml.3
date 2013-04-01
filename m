Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab3DAJso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:48:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58540 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3DAJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:48:43 -0400
X-AuditID: cbfee68e-b7f946d000001e37-71-515957faed4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 20/27] rtc: rtc-pcf8583: use devm_*() functions
Date: Mon, 01 Apr 2013 18:48:41 +0900
Message-id: <001f01ce2ebe$1798b1f0$46ca15d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAOMHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI91f4ZGBBgeucFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceDse7aC5TwVr3Y+Y29g7OPqYuTkkBAwkWh8cZMdwhaTuHBvPVsXIxeHkMAyRonV
	7deZYYoObOxmhUhMZ5R4cn0zK0hCSOAXo8SFjywgNpuAmsSXL4eBJnFwiAjoS7S1aIDUMwv0
	Mkqc6d3NDlFvK/Hj7HewoZwCdhJvFs5jBLGFBewl/h58AhZnEVCVWH78DNh8XqD6Z6fvsEHY
	ghI/Jt8D28UsoCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJXH9+lRGiRERi34t3jCD3
	SAg8Ypc4fXM3E8QuAYlvkw+xQPTKSmw6APWvpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCGR2reD8eYB60OMyUDrJzJLiSbnAyM9ryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Max9tyHKeKShj
	OeXQPNM2nVsnWlcErtwcdPhT3ZrXj8//8/M5GVHp/K82x6bEasXtKX7O1Zs5Ax2NRb6nb2Vs
	2t1zyabLmsVVz9w8syT904qbTmsWbZO9GFejO/GgsNDzm1smxXssvCYxz27HueWy3DmC+WFr
	JzcnVQg53y1b7pnFtWZO95XDSizFGYmGWsxFxYkAdK56eeoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1f4ZGBBiuvs1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHg7Hu2guU8Fa92PmNvYOzj6mLk5JAQMJE4
	sLGbFcIWk7hwbz1bFyMXh5DAdEaJJ9c3gyWEBH4xSlz4yAJiswmoSXz5cpi9i5GDQ0RAX6Kt
	RQOknlmgl1HiTO9udoh6W4kfZ78zg9icAnYSbxbOYwSxhQXsJf4efAIWZxFQlVh+/AzYfF6g
	+men77BB2IISPybfA9vFLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSVx/fpURokRE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBp4
	Jr2DcVWDxSFGAQ5GJR7eiAsRgUKsiWXFlbmHGCU4mJVEeH2+AYV4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5ii8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBUWxN5EZ2RfMnLz+FLJy4PL9o8fezN0In8r/ujVr/LvRn0enwx3mhTCwfFrjG8EdF3J5f
	9eK7t+fd37v3XZwt+/7eFodp0Rc85IPf/V9+QkFzfV/4kf+Pp916zKtaUtvKItvDxqMg875d
	7uDphgsLEnQPf+hJveC+Tu5jk3bz+/L1l5K9VXZEPVdiKc5INNRiLipOBABuy9xbRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf8583.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 5f97c61..95886dc 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -268,39 +268,29 @@ static int pcf8583_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct pcf8583 *pcf8583;
-	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	pcf8583 = kzalloc(sizeof(struct pcf8583), GFP_KERNEL);
+	pcf8583 = devm_kzalloc(&client->dev, sizeof(struct pcf8583),
+				GFP_KERNEL);
 	if (!pcf8583)
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, pcf8583);
 
-	pcf8583->rtc = rtc_device_register(pcf8583_driver.driver.name,
-			&client->dev, &pcf8583_rtc_ops, THIS_MODULE);
+	pcf8583->rtc = devm_rtc_device_register(&client->dev,
+				pcf8583_driver.driver.name,
+				&pcf8583_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8583->rtc)) {
-		err = PTR_ERR(pcf8583->rtc);
-		goto exit_kfree;
-	}
+	if (IS_ERR(pcf8583->rtc))
+		return PTR_ERR(pcf8583->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(pcf8583);
-	return err;
 }
 
 static int pcf8583_remove(struct i2c_client *client)
 {
-	struct pcf8583 *pcf8583 = i2c_get_clientdata(client);
-
-	if (pcf8583->rtc)
-		rtc_device_unregister(pcf8583->rtc);
-	kfree(pcf8583);
 	return 0;
 }
 
-- 
1.7.2.5


