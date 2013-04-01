Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab3DAJt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:49:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20688 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3DAJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:49:56 -0400
X-AuditID: cbfee68d-b7f786d000005188-da-515958401d5f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 24/27] rtc: rtc-s35390a: use devm_*() functions
Date: Mon, 01 Apr 2013 18:49:52 +0900
Message-id: <002301ce2ebe$41d6c060$c5844120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAQ5Iw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY12HiMhAg7kn1S2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuD89vqCFt+Lq+/AGxpNcXYycHBICJhLnfvxkh7DFJC7cW8/WxcjFISSwjFHi8KK9
	LDBF5zefYIJILGKU+Hr9ATuE84tRYu/JzWDtbAJqEl++HAayOThEBPQl2lo0QGqYBXoZJc70
	7garERKwlfhx9jsziM0pYCfxZuE8RpB6YQF7icbpmSBhFgFViaYjX8BKeIHKF9xtYYSwBSV+
	TL4HdhCzgJbE+p3HmSBseYnNa94yg4yREFCXePRXFyQsImAkMeXcIqgSEYl9L94xgpwjIXCL
	XaLt6xJGiF0CEt8mH2KB6JWV2HSAGeJfSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVT
	C5ILipPSiwz1ihNzi0vz0vWS83M3MUKitHcH4+0D1ocYk4HWT2SWEk3OB0Z5Xkm8obGZkYWp
	iamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY7TlK9wm71POLZO25
	px4wrzWW57d1pX1kvF39nrbqpVrXea4ZrJi0R+zXm4P/Yo4k2j7gqOFhNnPZGS6v0598WXj1
	q5sNtz7kRU5fWz3VvO7PzBRDnw/RM6Wfufgdnz0nk+WOwoIjH25Mn1C40VduoVjPOe6b9/52
	aN38w2v833W30aGZdvv+K7EUZyQaajEXFScCAC20sGPoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAV2HiMhAg5tXlC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLg/Pb6ghbfi6vvwBsaTXF2MnBwSAiYS5zef
	YIKwxSQu3FvP1sXIxSEksIhR4uv1B+wQzi9Gib0nN7ODVLEJqEl8+XIYyObgEBHQl2hr0QCp
	YRboZZQ407sbrEZIwFbix9nvzCA2p4CdxJuF8xhB6oUF7CUap2eChFkEVCWajnwBK+EFKl9w
	t4URwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wgYyQE1CUe/dUFCYsIGElMObcIqkREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAp4Jr2D
	cVWDxSFGAQ5GJR7eiAsRgUKsiWXFlbmHGCU4mJVEeH2+AYV4UxIrq1KL8uOLSnNSiw8xJgM9
	OpFZSjQ5H5ie8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	cZkUw/1TVmtXhtzulOD88uHaQWXl1OdpDplpimJNvx3+bmJ58eNlhtsPy+KS0I0BTC0817qO
	p55VFkyU6Gfz05b7ZcfXNGveum9z+Z0efKnS3nvy9/bL6WpXnlz+2Vl3vPjO/lK50rv5D6X2
	Rp084p8zQdDJhuvyZd/StwVrMxdb34lNZOw7psRSnJFoqMVcVJwIAJRKlXdFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-s35390a.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 8a09232..f40afdd 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -338,7 +338,8 @@ static int s35390a_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	s35390a = kzalloc(sizeof(struct s35390a), GFP_KERNEL);
+	s35390a = devm_kzalloc(&client->dev, sizeof(struct s35390a),
+				GFP_KERNEL);
 	if (!s35390a) {
 		err = -ENOMEM;
 		goto exit;
@@ -386,8 +387,9 @@ static int s35390a_probe(struct i2c_client *client,
 
 	device_set_wakeup_capable(&client->dev, 1);
 
-	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
-				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
+	s35390a->rtc = devm_rtc_device_register(&client->dev,
+					s35390a_driver.driver.name,
+					&s35390a_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(s35390a->rtc)) {
 		err = PTR_ERR(s35390a->rtc);
@@ -399,7 +401,6 @@ exit_dummy:
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
 			i2c_unregister_device(s35390a->client[i]);
-	kfree(s35390a);
 
 exit:
 	return err;
@@ -408,15 +409,12 @@ exit:
 static int s35390a_remove(struct i2c_client *client)
 {
 	unsigned int i;
-
 	struct s35390a *s35390a = i2c_get_clientdata(client);
+
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
 			i2c_unregister_device(s35390a->client[i]);
 
-	rtc_device_unregister(s35390a->rtc);
-	kfree(s35390a);
-
 	return 0;
 }
 
-- 
1.7.2.5


