Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab3DAJpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:45:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:45:01 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f4-515956ffca98
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 07/27] rtc: rtc-ds1390: use devm_*() functions
Date: Mon, 01 Apr 2013 18:44:31 +0900
Message-id: <001201ce2ebd$82ac7540$88055fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAE4fQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY93/YZGBBk9mWFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMfXqZpaCaTwVj9rPsDUwfuPsYuTkkBAwkdja1skIYYtJXLi3nq2LkYtDSGAZo8Tq
	zm52mKKzm9ayQCQWMUr8mr+HGcL5xShx9OchsHY2ATWJL18OA3VwcIgI6Eu0tWiA1DAL9DJK
	nOndDTZJSMBW4sfZ78wgNqeAncSbhfPAeoWB7HPT97CA2CwCqhIXll9hArF5geqfffwEZQtK
	/Jh8D6yGWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwktjRu5oRokREYt+Ld4wg90gI
	3GOXePN3GSvELgGJb5MPsUD0ykpsOsAM8bCkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSelFRnrFibnFpXnpesn5uZsYIbHat4Px5gHrQ4zJQOsnMkuJJucDYz2vJN7Q2MzI
	wtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyKASdvsjYGLl9g
	G913OeRLvYzVJyu7ifE3vqvrF6Xb2O18Wpl8betNzy5G+z2+/Tt2CFYfkWpJrPJslOypPnZ3
	Sb8Dy+IPkhv3buLXuT/Hg1FWwKusTvnh2/MVdrmsBsbLXZO5M9ZprXMqEKgV4NxyeZbuC0Eu
	38ePbF21fu++2MDbuHWmgxJLcUaioRZzUXEiABGXt9nrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3/YZGBBkuvmlgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDH16maWgmk8FY/az7A1MH7j7GLk5JAQMJE4
	u2ktC4QtJnHh3nq2LkYuDiGBRYwSv+bvYYZwfjFKHP15iBGkik1ATeLLl8PsXYwcHCIC+hJt
	LRogNcwCvYwSZ3p3s4PUCAnYSvw4+50ZxOYUsJN4s3AeWK8wkH1u+h6wbSwCqhIXll9hArF5
	geqfffwEZQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwktjRu5oRokRE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcCJ4
	JrWDcWWDxSFGAQ5GJR7eiAsRgUKsiWXFlbmHGCU4mJVEeH2+AYV4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBUUKVyy8g36fvc0l1+dQL51Uv8PPPuTBbZvKEmp07D5Suv5ceoPVPwfhb0o695e02cTWH
	3lz6ZSF0ijXgSLybWk7sp6q1J6ev8HCV2a5yVffeuYMTjQ5KrAtJOlCRcb5g64HDQp8esMeH
	HJ3B4HL9Ca+ItEjaieqCStU22QPHA0TvT9bv/eY2TYmlOCPRUIu5qDgRAPcDDM5IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1390.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index f994257..33e51c6 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -131,7 +131,7 @@ static int ds1390_probe(struct spi_device *spi)
 	spi->bits_per_word = 8;
 	spi_setup(spi);
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	chip = devm_kzalloc(&spi->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip) {
 		dev_err(&spi->dev, "unable to allocate device memory\n");
 		return -ENOMEM;
@@ -141,16 +141,14 @@ static int ds1390_probe(struct spi_device *spi)
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
 	if (res != 0) {
 		dev_err(&spi->dev, "unable to read device\n");
-		kfree(chip);
 		return res;
 	}
 
-	chip->rtc = rtc_device_register("ds1390",
-				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&spi->dev, "ds1390",
+					&ds1390_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		dev_err(&spi->dev, "unable to register device\n");
 		res = PTR_ERR(chip->rtc);
-		kfree(chip);
 	}
 
 	return res;
@@ -158,11 +156,6 @@ static int ds1390_probe(struct spi_device *spi)
 
 static int ds1390_remove(struct spi_device *spi)
 {
-	struct ds1390 *chip = spi_get_drvdata(spi);
-
-	rtc_device_unregister(chip->rtc);
-	kfree(chip);
-
 	return 0;
 }
 
-- 
1.7.2.5


