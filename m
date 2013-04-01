Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3DAJth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:49:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58665 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab3DAJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:49:36 -0400
X-AuditID: cbfee68d-b7f786d000005188-22-5159582e0953
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 23/27] rtc: rtc-rs5c372: use devm_*() functions
Date: Mon, 01 Apr 2013 18:49:34 +0900
Message-id: <002201ce2ebe$37558ae0$a600a0a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAQP+w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA139iMhAgyPNzBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlvPmzlbVgnnDF/E8NLA2MK/m7GDk5JARMJM5ve88OYYtJXLi3nq2LkYtDSGAZo8S0
	7j2MMEWnn85ihEgsYpR48W0xC4Tzi1Hi1ZH5TCBVbAJqEl++HAYaxcEhIqAv0daiAVLDLNDL
	KHGmdzfYCiEBW4kfZ78zg9icAnYSbxbOA9sgLGAv0bRqGVgNi4CqxMnv58HivED1D6ZvYIWw
	BSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHCIgJGEh0/uhghSkQk9r14B/aA
	hMAjdokdzSfZIHYJSHybfIgFoldWYtMBZoiHJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKs
	YhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ1d4djLcPWB9iTAZaP5FZSjQ5HxjreSXxhsZm
	RhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgnBmhvX9fyU+1
	xs+sD1//zzftcw060jHtUZS18Dy/yw5cK2YFlDuGTXm+0uDut0o33/3KE2L5Vn+csHbXSuaU
	n08vbhdf2/ohW3nl5rYZLB25O1W16lKEdtpZbD49b2Hm5cu7Trw/kbj/+p6/jtX3JR6mLL2p
	klU7wV/0lqnV5+LIa4G3WBkLvyixFGckGmoxFxUnAgCn9vnx6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV29iMhAg6NvrSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHjzZytrwTzhivmfGlgaGFfydzFyckgImEic
	fjqLEcIWk7hwbz1bFyMXh5DAIkaJF98Ws0A4vxglXh2ZzwRSxSagJvHly2H2LkYODhEBfYm2
	Fg2QGmaBXkaJM7272UFqhARsJX6c/c4MYnMK2Em8WTgPbIOwgL1E06plYDUsAqoSJ7+fB4vz
	AtU/mL6BFcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJdPzoYoQo
	EZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	CJ5J72Bc1WBxiFGAg1GJhzfiQkSgEGtiWXFl7iFGCQ5mJRFen29AId6UxMqq1KL8+KLSnNTi
	Q4zJQI9OZJYSTc4HJqm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamCsDv+Tf9hb3OhWiuB3xYOysrOufGx4w3H4/WqeQMXJa/VOLAm2tRXc1WV48bCzz8JM
	wYcsH46dnLrvzo2E+WGd/+8dKfs936/dT3lihfiq7P4l1R/CbFpE9i3yYv63IJDTuZHLf8Ov
	MuuEiknJ3B1npQXi0zUFNmm4HYxfq3Zvf9KcvgufytOUWIozEg21mIuKEwEXN0JESAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rs5c372.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 581739f..224d634 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -579,7 +579,9 @@ static int rs5c372_probe(struct i2c_client *client,
 		}
 	}
 
-	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
+	rs5c372 = devm_kzalloc(&client->dev, sizeof(struct rs5c372),
+				GFP_KERNEL);
+	if (!rs5c372) {
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -594,7 +596,7 @@ static int rs5c372_probe(struct i2c_client *client,
 
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
-		goto exit_kfree;
+		goto exit;
 
 	/* clock may be set for am/pm or 24 hr time */
 	switch (rs5c372->type) {
@@ -617,7 +619,7 @@ static int rs5c372_probe(struct i2c_client *client,
 		break;
 	default:
 		dev_err(&client->dev, "unknown RTC type\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	/* if the oscillator lost power and no other software (like
@@ -629,7 +631,7 @@ static int rs5c372_probe(struct i2c_client *client,
 	err = rs5c_oscillator_setup(rs5c372);
 	if (unlikely(err < 0)) {
 		dev_err(&client->dev, "setup error\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	if (rs5c372_get_datetime(client, &tm) < 0)
@@ -648,38 +650,28 @@ static int rs5c372_probe(struct i2c_client *client,
 			);
 
 	/* REVISIT use client->irq to register alarm irq ... */
-
-	rs5c372->rtc = rtc_device_register(rs5c372_driver.driver.name,
-				&client->dev, &rs5c372_rtc_ops, THIS_MODULE);
+	rs5c372->rtc = devm_rtc_device_register(&client->dev,
+					rs5c372_driver.driver.name,
+					&rs5c372_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rs5c372->rtc)) {
 		err = PTR_ERR(rs5c372->rtc);
-		goto exit_kfree;
+		goto exit;
 	}
 
 	err = rs5c_sysfs_register(&client->dev);
 	if (err)
-		goto exit_devreg;
+		goto exit;
 
 	return 0;
 
-exit_devreg:
-	rtc_device_unregister(rs5c372->rtc);
-
-exit_kfree:
-	kfree(rs5c372);
-
 exit:
 	return err;
 }
 
 static int rs5c372_remove(struct i2c_client *client)
 {
-	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rs5c372->rtc);
 	rs5c_sysfs_unregister(&client->dev);
-	kfree(rs5c372);
 	return 0;
 }
 
-- 
1.7.2.5


