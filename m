Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3IKDJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:09:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39422 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3IKDJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:09:02 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-0f-522fdecc3015
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Anish Kumar'" <anish198519851985@gmail.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Mike Lockwood'" <lockwood@android.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
Subject: [PATCH V2] extcon: use dev_get_platdata()
Date: Wed, 11 Sep 2013 12:08:59 +0900
Message-id: <004201ceae9c$42c82ff0$c8588fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6unDrAx+mWGKleQ8iIMK4N+uj4iA==
Content-language: ko
x-cr-hashedpuzzle: AncR LJ6l QlN0 Waj3 b1B6 feq/ nJpO qLBC r33J u/+Y xRX/ y7ps
 zIcV ACC6eg== ADpXoQ==
 AE/99w==;9;YQBuAGkAcwBoADEAOQA4ADUAMQA5ADgANQAxADkAOAA1AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBjAHcAMAAwAC4AYwBoAG8AaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGcAZwBAAHMAbABpAG0AbABvAGcAaQBjAC4AYwBvAC4AdQBrADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAYQByAHMAQABtAGUAdABhAGYAbwBvAC4AZABlADsAbABkAGUAdwBhAG4AZwBhAG4AQABuAHYAaQBkAGkAYQAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAbwBjAGsAdwBvAG8AZABAAGEAbgBkAHIAbwBpAGQALgBjAG8AbQA7AG0AeQB1AG4AZwBqAG8AbwAuAGgAYQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{ECE3809F-BCCE-4FBA-8A8D-D7C753353852};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 11 Sep 2013 03:08:46
 GMT;WwBQAEEAVABDAEgAIABWADIAXQAgAGUAeAB0AGMAbwBuADoAIAB1AHMAZQAgAGQAZQB2AF8AZwBlAHQAXwBwAGwAYQB0AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {ECE3809F-BCCE-4FBA-8A8D-D7C753353852}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI90z9/SDDJatYLe4fKOL2eLlIU2L
	61+es1r0b3GxuLzwEqvFksnzWS2W7lvNYnF51xw2i3+PtrFb3G5cwebA5bFt9zZWj52z7rJ7
	LHlziNWjt/kdm0ffllWMHlOn/GX0+LxJLoA9issmJTUnsyy1SN8ugStjysVrbAV3BSt2PK1q
	YJzC38XIySEhYCLx+PwONghbTOLCvfVANheHkMAyRomp22cwwxT9uvyQCSIxnVFi65lV7BDO
	L0aJWdfbWUCq2ATUJL58OcwOYosIaElM7JwJ1sEscJxJ4vS9GWBFwgJGEh39s8FsFgFViY3P
	DrKC2LwCthItHWtYIGxBiR+T74HZzECD1u88zgRhy0tsXvMW6CQOoJPUJR791QUxRQT0JK4/
	y4OoEJHY9+IdI8haCYEOdonv394yQnxgKtHWsRbqm14Oif3TxCBOEJD4NvkQC8RIWYlNB6BK
	JCUOrrjBMgHoOyQHzUJy0CwkB81CsnoBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJBY
	793BePuA9SHGZKD1E5mlRJPzgakiryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MMz6+cp/8+MUUfbap5+TulS+7quu15/pdJ7YPTYbHK7rY1hUf
	N4wobfGJvJyxPitv5x/7PgeB2rQd3t+Xuqr5LjIUNJV3u902OW1ZTF/Vfw2W9zMnci27wXkz
	KmOrEEflKYMZr7btMQ37ofD40iLbGYslG5NbOu9zXe7dN/X4+1i5Ypa+61k5SizFGYmGWsxF
	xYkAzrjCMgsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd0z9/SDDL50MllcvtHFbPHykKbF
	9S/PWS36t7hYXF54idViyeT5rBZL961msbi8aw6bxb9H29gtbjeuYHPg8ti2exurx85Zd9k9
	lrw5xOrR2/yOzaNvyypGj6lT/jJ6fN4kF8Ae1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsI4xY8rFa2wFdwUrdjytamCcwt/FyMkhIWAi8evyQyYIW0ziwr31bF2MXBxCAtMZ
	JbaeWcUO4fxilJh1vZ0FpIpNQE3iy5fD7CC2iICWxMTOmUwgRcwCx5kkTt+bAVYkLGAk0dE/
	G8xmEVCV2PjsICuIzStgK9HSsYYFwhaU+DH5HpjNDDRo/c7jTBC2vMTmNW+Zuxg5gE5Sl3j0
	VxfEFBHQk7j+LA+iQkRi34t3jCBrJQQ62CW+f3vLCPGBqURbx1rmCYxCs5BsmIVkwywkG2Yh
	mbWAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAqeSa1g3Flg8UhRgEORiUe3hty+kFC
	rIllxZW5hxglOJiVRHinOgGFeFMSK6tSi/Lji0pzUosPMSYDA2Ais5Rocj4wzeWVxBsam5gZ
	WRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6P5nYrXmskb5axfiaZWKjJe
	0i6tKjuhUC3KxMzScXazte+0jf/rBQ/YXTIxFopN/3N1VsKLlxu0n+yTlinwrI7lv/wz890E
	qR6NTUrHFgm+/dI1s6jgEJfKibtsmZJsV1q5+12ylG5s4ODxbXzl/C2VXW+/Dnfvh9fvw3cd
	Xs6fv9VpqminjhJLcUaioRZzUXEiAK4z2mJpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v2:
- squashed 3 patches into a single patch

 drivers/extcon/extcon-adc-jack.c |    2 +-
 drivers/extcon/extcon-gpio.c     |    2 +-
 drivers/extcon/extcon-palmas.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 5985807..c0e0e20 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -95,7 +95,7 @@ static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
 static int adc_jack_probe(struct platform_device *pdev)
 {
 	struct adc_jack_data *data;
-	struct adc_jack_pdata *pdata = pdev->dev.platform_data;
+	struct adc_jack_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int i, err = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index f874c30..c4d5a19 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -78,7 +78,7 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
-	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
 	int ret = 0;
 
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 89fdd05..0c2fb68 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -135,7 +135,7 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
 static int palmas_usb_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
-	struct palmas_usb_platform_data	*pdata = pdev->dev.platform_data;
+	struct palmas_usb_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	struct palmas_usb *palmas_usb;
 	int status;
-- 
1.7.10.4


