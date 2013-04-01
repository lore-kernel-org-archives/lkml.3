Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3DAJoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:44:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20007 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:44:52 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-34-51595713b06a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 08/27] rtc: rtc-ds2404: use devm_*() functions
Date: Mon, 01 Apr 2013 18:44:50 +0900
Message-id: <001301ce2ebd$8e279b20$aa76d160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAFoQQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY13h8MhAg0ldXBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlzJ79l7ngKnfF5i9nGBsYj3B2MXJySAiYSDRtn80IYYtJXLi3nq2LkYtDSGAZo8TD
	11PZYYrOb7kFlZjOKNG6dQI7hPOLUWJx51GwKjYBNYkvXw4D2RwcIgL6Em0tGiA1zAK9jBJn
	eneD1QgJ2Er8OPudGcTmFLCTeLNwHthqYSD7/rUNLCC9LAKqEl/+qYGEeYHKHy7bywphC0r8
	mHyPBcRmFtCSWL/zOBOELS+xec1bZpBWCQF1iUd/dUHCIgJGEjfmLGWEKBGR2PfiHdST99gl
	5j4JALFZBAQkvk0+xALRKiux6QAzRImkxMEVN1gmMErMQrJ4FpLFs5AsnoVkwwJGllWMoqkF
	yQXFSelFpnrFibnFpXnpesn5uZsYIXE6cQfj/QPWhxiTgdZPZJYSTc4HxnleSbyhsZmRhamJ
	qbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhg7mBZPT7Mz3bZqh+sE
	93+VM9W1tx58OM9Y/9it5n+cJQ63jX8eCH/Qb2mUc0rjP2NH7oP2yIMxedXfHVcq/47msX9S
	q1iyeM3ExDXXWup/Gl6cXlo+k/XAzgvnGY9kuHPpbTFf9c8nXP2VY+PLK/x5AQvb5gt//LPl
	VJ/fno+VZbm77kS+5T6pxFKckWioxVxUnAgAf//4LOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3h8MhAg/UXWC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJg9+y9zwVXuis1fzjA2MB7h7GLk5JAQMJE4
	v+UWG4QtJnHh3nogm4tDSGA6o0Tr1gnsEM4vRonFnUfZQarYBNQkvnw5DGRzcIgI6Eu0tWiA
	1DAL9DJKnOndDVYjJGAr8ePsd2YQm1PATuLNwnmMILYwkH3/2gYWkF4WAVWJL//UQMK8QOUP
	l+1lhbAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERASOJG3OWMkKUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOA8+k
	djCubLA4xCjAwajEwxtxISJQiDWxrLgy9xCjBAezkgivzzegEG9KYmVValF+fFFpTmrxIcZk
	oD8nMkuJJucDU1ReSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBK
	NTCG6r3f4+KcpXba8PQuF/VHyxJSz30WmbhN7WWh6bqoaTJTE2uUdOa8ElHQMKgNFhU2cDxx
	5eQmtqVlnE+/h4cssDjG1Lxrh+S2yf5mH5Qz5gol/GtedffEjzcKnVu++q5teqHl1j5/UeAx
	jSrTAPcry//7fFc+KLEk+n1/ybLE3XOmbGvT7tRTYinOSDTUYi4qTgQAYK+A7kcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds2404.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index b04fc42..2ca5a23 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -228,7 +228,7 @@ static int rtc_probe(struct platform_device *pdev)
 	struct ds2404 *chip;
 	int retval = -EBUSY;
 
-	chip = kzalloc(sizeof(struct ds2404), GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(struct ds2404), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -244,8 +244,8 @@ static int rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, chip);
 
-	chip->rtc = rtc_device_register("ds2404",
-				&pdev->dev, &ds2404_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&pdev->dev, "ds2404",
+					&ds2404_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		retval = PTR_ERR(chip->rtc);
 		goto err_io;
@@ -257,20 +257,14 @@ static int rtc_probe(struct platform_device *pdev)
 err_io:
 	chip->ops->unmap_io(chip);
 err_chip:
-	kfree(chip);
 	return retval;
 }
 
 static int rtc_remove(struct platform_device *dev)
 {
 	struct ds2404 *chip = platform_get_drvdata(dev);
-	struct rtc_device *rtc = chip->rtc;
-
-	if (rtc)
-		rtc_device_unregister(rtc);
 
 	chip->ops->unmap_io(chip);
-	kfree(chip);
 
 	return 0;
 }
-- 
1.7.2.5


