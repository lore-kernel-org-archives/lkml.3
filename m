Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3CNIYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:24:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26529 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3CNIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:24:32 -0400
X-AuditID: cbfee690-b7f656d0000007e3-a6-5141893e4fcd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 30/30] rtc: rtc-x1205: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:24:30 +0900
Message-id: <00a101ce208d$598d8ed0$0ca8ac70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAfHrA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI127TsdAg5cXzSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmDVlMXtBP1fF2mVnmRsY13J0MXJySAiYSPw4dIodwhaTuHBvPRuILSSwjFFi98LK
	LkYOsJr3a526GLmAwtMZJa5s/MYI4fxilDjdu58JpIFNQE3iy5fD7CANIgL6Em0tGiA1zAK9
	jBJneneDxYUEbCWu/7cDMTkF7CQ2rBcD6RQWcJW4OuEUM4jNIqAq8XPSFLBzeIGqzy16xghh
	C0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZogz1SUe/dUFCYsIGEnsvrQbqlxEYt+Ld2AXSwjc
	Y5dYe/gy1C4BiW+TD7FA9MpKbDrADAkFSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVT
	C5ILipPSi0z0ihNzi0vz0vWS83M3MUJidMIOxnsHrA8xJgOtn8gsJZqcD4zxvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNvoHTxJ8vbLS9twd
	tYd9mU2Rrqv6vh05mDdT4oxN5QqZ8uez5fSzZ+6uyP6aO3G7inbYpRqFyWG5VQayMcvD3jZx
	771ZYCMq5O3yNt1NKNFq+jvzjznrlzas6J5ycvf3hMOdcZ/2WTzYX7+/suC7361XvW+WbHt7
	xkar646J4UcH7SDphZcPK7EUZyQaajEXFScCABZROgXnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV27TsdAg/69RhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsyaspi9oJ+rYu2ys8wNjGs5uhg5OCQETCTe
	r3XqYuQEMsUkLtxbz9bFyMUhJDCdUeLKxm+MEM4vRonTvfuZQKrYBNQkvnw5zA7SLCKgL9HW
	ogFSwyzQyyhxpnc3WFxIwFbi+n87EJNTwE5iw3oxkE5hAVeJqxNOMYPYLAKqEj8nTWEHsXmB
	qs8tesYIYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIk9UlHv3VBQmLCBhJ7L60G6pcRGLf
	i3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAKeCa1
	g3Flg8UhRgEORiUe3gP9DoFCrIllxZW5hxglOJiVRHg9vRwDhXhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmJ7ySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNT
	qoHR7O3+qHizdaszVE2YLJu+nrxlp7Nq3WrPmbGXZvxRO39ZVZov+bjNrFn7w+MZVnq4zWOd
	deOv0qzEf/f/6i0RWb1Cfbv15++eNdN3BYtrHeHg8HY/6r066WLWAym/CIGn+9+tf1kRkJX+
	c/MK+ZOfdsTuimDmC0g+p7bSh3vW0XM65qcfiKfeUmIpzkg01GIuKk4EAB+hNWJFAwAA
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
 drivers/rtc/rtc-x1205.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index f36e59c..fa9b067 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -630,8 +630,8 @@ static int x1205_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(x1205_driver.driver.name, &client->dev,
-				&x1205_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, x1205_driver.driver.name,
+					&x1205_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -653,21 +653,13 @@ static int x1205_probe(struct i2c_client *client,
 
 	err = x1205_sysfs_register(&client->dev);
 	if (err)
-		goto exit_devreg;
+		return err;
 
 	return 0;
-
-exit_devreg:
-	rtc_device_unregister(rtc);
-
-	return err;
 }
 
 static int x1205_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
 	x1205_sysfs_unregister(&client->dev);
 	return 0;
 }
-- 
1.7.2.5


