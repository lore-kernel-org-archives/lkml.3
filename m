Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3LAX5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:57:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14230 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3LAX5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:57:31 -0500
X-AuditID: cbfee691-b7f666d0000048b0-30-529bcce51d8e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 5/8] backlight: tosa: use devm_backlight_device_register()
Date: Mon, 02 Dec 2013 08:57:24 +0900
Message-id: <000401ceeef1$1511cc20$3f356460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAADJPQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ92nZ2YHGew/xWwxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8X4LW0EfZ8XMpScYGxiP
	sncxcnBICJhIzFqd1cXICWSKSVy4t56ti5GLQ0hgGaPE3IePmSASJhL3H/9jBbGFBBYxSrx6
	agBR9ItR4srMHrAiNgE1iS9fDoMNFRHQl2hr0QAxmQVcJI5OE4FotZXY8Og8WDWngJ3EhJt/
	wGxhAS+JO22X2UFsFgFVibVLrjGD2LxA9Xd/zWCFsAUlfky+xwJiMwtoSazfeZwJwpaX2Lzm
	LTPEK+oSj/7qgoRFBIwkti3YwAxRIiKx78U7RpCLJQT2sUv0nv3BBrFLQOLb5EMsEL2yEpsO
	MEN8KylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7u
	JkZI5E3cwXj/gPUhxmSg9ROZpUST84GRm1cSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjHkleuFm7oHHM2zXmZg8s3r8Yqn07r4bfAExC9/H/lQW
	Lim7XzwtXY5L/uWjFd/7zfW8O4yzBawvvVwqd8E8+N7fmk1ZoX9fO8fk1HoorxERDFycyjpf
	Jf8z19SZhwQ/P034f9GaJychiz/zyar12rb7P/x89mMb1xyD/f1Grwt9P3vLbGexV2Ipzkg0
	1GIuKk4EAKoDfyLSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd2nZ2YHGSyWs5izfg2bxeWFl1gt
	Lu+aw+bA7HFixm8Wj74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAFapKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPMeL+FraCPs2Lm0hOMDYxH2bsYOTkkBEwk7j/+xwphi0lcuLeeDcQWEljEKPHqqUEX
	IxeQ/YtR4srMHiaQBJuAmsSXL4eBmjk4RAT0JdpaNEBMZgEXiaPTRCBabSU2PDoPVs0pYCcx
	4eYfMFtYwEviTttlsLUsAqoSa5dcYwaxeYHq7/6awQphC0r8mHyPBcRmFtCSWL/zOBOELS+x
	ec1bZpBVEgLqEo/+6oKERQSMJLYt2MAMUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOK6fSe1gXNlgcYhRgINRiYe34tjsICHWxLLiytxD
	jBIczEoivBZfZwUJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w5eSVxBsam5gZWRqZWRiZ
	mJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+M03tuXEtUP3TLP0D5hffDhp0ux8gmW
	Jet+Hu/LCdgakbbVNKPwubp7/TbvzYnH0mxYI0Md7T60bN+kpWGvdTQm94WDer3FpmuTfIQ2
	LN5RKPE59LnHxAkKTddKTlSnzHj+Z4vHNnXFnSK/c6oWH8+8tplLLfbay8RLr9sF5/4IiVKt
	zdby7FViKc5INNRiLipOBABXry0qLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_bl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index b8db933..3ad6765 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -105,8 +105,9 @@ static int tosa_bl_probe(struct i2c_client *client,
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 512 - 1;
-	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
-					     &bl_ops, &props);
+	data->bl = devm_backlight_device_register(&client->dev, "tosa-bl",
+						&client->dev, data, &bl_ops,
+						&props);
 	if (IS_ERR(data->bl)) {
 		ret = PTR_ERR(data->bl);
 		goto err_reg;
@@ -128,9 +129,7 @@ static int tosa_bl_remove(struct i2c_client *client)
 {
 	struct tosa_bl_data *data = i2c_get_clientdata(client);
 
-	backlight_device_unregister(data->bl);
 	data->bl = NULL;
-
 	return 0;
 }
 
-- 
1.7.10.4


