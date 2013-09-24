Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3IXJHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:07:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3IXJHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:07:02 -0400
X-AuditID: cbfee68e-b7f756d000004512-c9-524156357f47
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 04/22] backlight: adp8860: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:07:01 +0900
Message-id: <004a01ceb905$6e0f3af0$4a2db0d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAFYlQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ13TMMcgg9vNchZz1q9hs7i88BKr
	xeVdc9gsJhzezG6xe9dTVgdWj1dXHT1OzPjN4rFn/g9Wj74tqxg9Pm+SC2CN4rJJSc3JLEst
	0rdL4MpYtuwma8EcnormP5/ZGhincnUxcnJICJhILJ22nwnCFpO4cG89WxcjF4eQwDJGiZub
	JrPCFN24e4EZIjGdUWLxof2sEM4vRon/NxcwglSxCahJfPlymL2LkYNDREBfoq1FA6SGWWAR
	o8T2B+0sIDVCArYS6z7MZgexOQXsJE4tPcMGYgsL+Eu8PPoELM4ioCoxfdsHsM28QPU3579i
	grAFJX5Mvgc2h1lAS2LztiZWCFteYvOat8wgeyUE1CUe/dUFCYsIGEn82DKHGaJERGLfi3eM
	IPdICDxil7h07iozxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCGR2reD8eYB60OMyUDrJzJLiSbnAyM9ryTe
	0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MUXbc7wL+
	S0oqWz1633oh5aJ1S1x0utDh9I/tDovfWxstS6+81nVgwxxW9uV7lN2STzFNCq+W7NbkOSB0
	RsUqlfey+hbeDYXn+Ga1xm01t1mR75nWtj7Ii/n22SPT+B+fVezjm1TedfPFn5OZ3+9MC929
	tj6obdrMDscStZTT5QpdjW1qW6SUWIozEg21mIuKEwE/XY3Q6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3TMMcgg74ZUhZz1q9hs7i88BKr
	xeVdc9gsJhzezG6xe9dTVgdWj1dXHT1OzPjN4rFn/g9Wj74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWLbsJmvBHJ6K5j+f2RoYp3J1MXJySAiYSNy4
	e4EZwhaTuHBvPVsXIxeHkMB0RonFh/azQji/GCX+31zACFLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFFjBLbH7SzgNQICdhKrPswmx3E5hSwkzi19AwbiC0s4C/x8ugTsDiLgKrE9G0fWEFs
	XqD6m/NfMUHYghI/Jt8Dm8MsoCWxeVsTK4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwkfmyZwwxR
	IiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	DTyT2sG4ssHiEKMAB6MSD+8Ob4cgIdbEsuLK3EOMEhzMSiK8N2wdg4R4UxIrq1KL8uOLSnNS
	iw8xJgM9OpFZSjQ5H5ii8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBcanLtwcfCzzTe966xgjteSZuNaX+id1xLymnsxWR25c2b1w+6buGgTzH3tYts/1j
	OLrNnxv9fLsp55T7NV0WgykLWYxrvaQ/2HQamp6IP5jFvPujj+r6xOAYqzOXpslMSdi/jD1v
	duHl+5b95uoL1j3nPfdq9sS30s/CI576TLqdaKNTkZLTocRSnJFoqMVcVJwIAM/2rIVHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8860_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 2f77f37..9d65671 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -711,8 +711,9 @@ static int adp8860_probe(struct i2c_client *client,
 
 	mutex_init(&data->lock);
 
-	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8860_bl_ops, &props);
+	bl = devm_backlight_device_register(&client->dev,
+				dev_driver_string(&client->dev),
+				&client->dev, data, &adp8860_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -728,7 +729,7 @@ static int adp8860_probe(struct i2c_client *client,
 
 	if (ret) {
 		dev_err(&client->dev, "failed to register sysfs\n");
-		goto out1;
+		return ret;
 	}
 
 	ret = adp8860_bl_setup(bl);
@@ -751,8 +752,6 @@ out:
 	if (data->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8860_bl_attr_group);
-out1:
-	backlight_device_unregister(bl);
 
 	return ret;
 }
@@ -770,8 +769,6 @@ static int adp8860_remove(struct i2c_client *client)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8860_bl_attr_group);
 
-	backlight_device_unregister(data->bl);
-
 	return 0;
 }
 
-- 
1.7.10.4


