Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3DAJpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:45:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35042 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:45:12 -0400
X-AuditID: cbfee690-b7f656d0000007e3-e3-515957267b9f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 09/27] rtc: rtc-fm3130: use devm_*() functions
Date: Mon, 01 Apr 2013 18:45:10 +0900
Message-id: <001401ce2ebd$99ed3780$cdc7a680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAGURA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfV218MhAg5tHLSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmLv2G0vBK66Klf9XsDYwvuToYuTkkBAwkbj68S8zhC0mceHeerYuRi4OIYFljBKv
	juxkgynqevqHBSIxnVFiyo9eZgjnF6NE96FHjCBVbAJqEl++HGbvYuTgEBHQl2hr0QCpYRbo
	ZZQ407ubHaRGSMBW4sfZ72DrOAXsJN4snAfWKwxkH9s8jQXEZhFQlWg9+BrM5gWqP7DpGDuE
	LSjxY/I9sDizgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQsImAksWD3BVaIEhGJfS/eMYLc
	IyFwj11iyrl+qF0CEt8mH2KB6JWV2HQAGhKSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihMTqhB2M9w5YH2JMBlo/kVlKNDkfGOt5JfGGxmZG
	FqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBk+8zHz3Hc/5ah
	x8nPD67ynqkxEK97MFMk6L3v2ns/Hyn2r9zYEq94/qBhTPO6r9t8+06ad2w9+OE158I/2R/N
	Fls/7u196b+wZM0UAUb1c0eOVui+u222yPzmifXX/i63nLkrbRmz9Esjm8oI+5+OZfG/WVbc
	WBm2NfOmUNLzLHeT3byKOWqdSizFGYmGWsxFxYkA1XDywusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV218MhAg2vtJhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsxd+42l4BVXxcr/K1gbGF9ydDFyckgImEh0
	Pf3DAmGLSVy4t56ti5GLQ0hgOqPElB+9zBDOL0aJ7kOPGEGq2ATUJL58OczexcjBISKgL9HW
	ogFSwyzQyyhxpnc3O0iNkICtxI+z35lBbE4BO4k3C+eB9QoD2cc2TwPbxiKgKtF68DWYzQtU
	f2DTMXYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBIYsHuC6wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8Ez
	6R2MqxosDjEKcDAq8fBGXIgIFGJNLCuuzD3EKMHBrCTC6/MNKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wCSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MzatnyNaXXw3W2KWU+kxmL1ed82HRXe9MKqvmVPz0c+uVP/OFx1vr3yJXg17XghALjciZ
	/8q6Cxze+Hu8UChxbzzw64nFhPPXsjP2f/Oqj3fpuP1c/sI/8z0B+t32U9xNzzrNdO+PMFs2
	ezJfX+KXQxG63+2bkwXuz72254zQ+wvp9rcjnbOUWIozEg21mIuKEwG6trk9SAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-fm3130.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 4d4ad3f..2835fb6 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -358,7 +358,7 @@ static int fm3130_probe(struct i2c_client *client,
 			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
-	fm3130 = kzalloc(sizeof(struct fm3130), GFP_KERNEL);
+	fm3130 = devm_kzalloc(&client->dev, sizeof(struct fm3130), GFP_KERNEL);
 
 	if (!fm3130)
 		return -ENOMEM;
@@ -507,7 +507,7 @@ bad_clock:
 
 	/* We won't bail out here because we just got invalid data.
 	   Time setting from u-boot doesn't work anyway */
-	fm3130->rtc = rtc_device_register(client->name, &client->dev,
+	fm3130->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&fm3130_rtc_ops, THIS_MODULE);
 	if (IS_ERR(fm3130->rtc)) {
 		err = PTR_ERR(fm3130->rtc);
@@ -517,16 +517,11 @@ bad_clock:
 	}
 	return 0;
 exit_free:
-	kfree(fm3130);
 	return err;
 }
 
 static int fm3130_remove(struct i2c_client *client)
 {
-	struct fm3130 *fm3130 = i2c_get_clientdata(client);
-
-	rtc_device_unregister(fm3130->rtc);
-	kfree(fm3130);
 	return 0;
 }
 
-- 
1.7.2.5


