Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3DAJpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:45:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35104 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:45:36 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ef-5159573a9a72
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 10/27] rtc: rtc-isl12022: use devm_*() functions
Date: Mon, 01 Apr 2013 18:45:30 +0900
Message-id: <001501ce2ebd$a5d37b40$f17a71c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAHFLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI12r8MhAgwWtZhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlPN/Yyl7QwVux4c9OtgbGc1xdjJwcEgImEmcblrJD2GISF+6tZ+ti5OIQEljGKDHz
	7wU2mKIf/26yQiSmM0qsmvGTCcL5xSgx9fZdsHY2ATWJL18OA9kcHCIC+hJtLRogNcwCvYwS
	Z3p3g9UICdhK/Dj7nRnE5hSwk3izcB4jiC0s4CDx4shLsBoWAVWJjuUTWEBsXqD6d3/eskPY
	ghI/Jt8DizMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSX7a8ZIMoEZHY9+IdI8g9
	EgKP2CWm75vACrFLQOLb5EMsEL2yEpsOMEM8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFl
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIrE7YwXjvgPUhxmSg9ROZpUST84GxnlcSb2hs
	ZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxv4rlk6Bii08
	dQLm7Ufv67TKaz0zPuiS9Pm9RN+GKamq4vf55dd22IVv37Twk1SSgVqqw8QPze84fog2me3w
	fWTDcrJvX6UH81Pt+JVF7DsZX072yvy0tyXheGu7d4Sf/d1nLhPm/q9V/dU2iWtWd7/Ls7gH
	3qoXIwLbPiU84fmfsPzYzFVKSizFGYmGWsxFxYkA5AYGVOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV2r8MhAg5ezjCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHi+sZW9oIO3YsOfnWwNjOe4uhg5OSQETCR+
	/LvJCmGLSVy4t56ti5GLQ0hgOqPEqhk/mSCcX4wSU2/fZQepYhNQk/jy5TCQzcEhIqAv0dai
	AVLDLNDLKHGmdzdYjZCArcSPs9+ZQWxOATuJNwvnMYLYwgIOEi+OvASrYRFQlehYPoEFxOYF
	qn/35y07hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJPFly0s2iBIR
	iX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYng
	mfQOxlUNFocYBTgYlXh4Iy5EBAqxJpYVV+YeYpTgYFYS4fX5BhTiTUmsrEotyo8vKs1JLT7E
	mAz06ERmKdHkfGCSyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGRsH/wV9Oek5/8UG+eMGBY1Xz9taUfvu1a+r8/+JnZqWaiDlI/P7EvTxKcVPy617nvr3p
	9xc9nXfl+7xKm0cL7t+a6/Ts3iy+lI54ixSBe0rlZjc8zl3iFlvyvvJ5feUCi5KEb++Xtkiz
	zzof46X6+2q4mrvqxdPBm/bdDNKrdj545PX5G39O1ggosRRnJBpqMRcVJwIAyT0XDEgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-isl12022.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 6b4298e..1af0aa5 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -252,12 +252,11 @@ static int isl12022_probe(struct i2c_client *client,
 {
 	struct isl12022 *isl12022;
 
-	int ret = 0;
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	isl12022 = kzalloc(sizeof(struct isl12022), GFP_KERNEL);
+	isl12022 = devm_kzalloc(&client->dev, sizeof(struct isl12022),
+				GFP_KERNEL);
 	if (!isl12022)
 		return -ENOMEM;
 
@@ -265,31 +264,17 @@ static int isl12022_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, isl12022);
 
-	isl12022->rtc = rtc_device_register(isl12022_driver.driver.name,
-					    &client->dev,
-					    &isl12022_rtc_ops,
-					    THIS_MODULE);
-
-	if (IS_ERR(isl12022->rtc)) {
-		ret = PTR_ERR(isl12022->rtc);
-		goto exit_kfree;
-	}
+	isl12022->rtc = devm_rtc_device_register(&client->dev,
+					isl12022_driver.driver.name,
+					&isl12022_rtc_ops, THIS_MODULE);
+	if (IS_ERR(isl12022->rtc))
+		return PTR_ERR(isl12022->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(isl12022);
-
-	return ret;
 }
 
 static int isl12022_remove(struct i2c_client *client)
 {
-	struct isl12022 *isl12022 = i2c_get_clientdata(client);
-
-	rtc_device_unregister(isl12022->rtc);
-	kfree(isl12022);
-
 	return 0;
 }
 
-- 
1.7.2.5


