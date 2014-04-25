Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaDYAoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:44:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaDYAmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:40 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-b4-5359af7b07db
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 7/9] extcon: adc-jack: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Fri, 25 Apr 2014 09:42:22 +0900
Message-id: <1398386544-16295-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSolu9PjLYoPWWisXB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNgctj06pONo+XE3+zefRt
	WcXoMXXKX0aP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlfF0X0hBn3DFthn/WBsYb/B3MXJy
	SAiYSCzZ9IUNwhaTuHBvPZDNxSEksJRR4mrvNFaYokt7J0AlpjNK7Oo8yASSEBJoYpI4fbAI
	xGYT0JLY/+IG2CQRAQWJzb3PWEEamAWeMUqcuHqCGSQhLBAmcWjGKbCpLAKqEnePLASzeQVc
	JU7MeAp1hpzEhz2P2EFsTgE3iUMnelkglrlKvDo3hwlkqITAJnaJxSufM0EMEpD4NvkQUBEH
	UEJWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYCSc/ves
	fwfj3QPWhxiTgcZNZJYSTc4HRlJeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamCc09l7zV1P5mZpRCHP9ldTks0al9bUc5muO8jMe//jz+vHN4u+
	WZh97EHavOPfXWuXzPOe3iD36su/79cjuYKZxCxfXVXOshE2VGq95uXvyZQy9eQhb8negNf/
	RPcFxPNPXB3esHZWptK+Vo2IzqzisjUW+3X7/36X7HaonP+YZeL2yfGlttxKLMUZiYZazEXF
	iQCpgHaHmgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd3q9ZHBBhPOyFgcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgznu4LKegTrtg24x9rA+MN/i5GTg4JAROJS3snsEHYYhIX7q0Hsrk4hASmM0rs6jzIBJIQ
	Emhikjh9sAjEZhPQktj/4gZYg4iAgsTm3mesIA3MAs8YJU5cPcEMkhAWCJM4NOMUK4jNIqAq
	cffIQjCbV8BV4sSMp1Db5CQ+7HnEDmJzCrhJHDrRywKxzFXi1bk5TBMYeRcwMqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI6zZ1I7GFc2WBxiFOBgVOLh/aAWGSzEmlhWXJl7iFGCg1lJ
	hFd5FVCINyWxsiq1KD++qDQntfgQYzLQVROZpUST84EpIK8k3tDYxMzI0sjc0MLI2Jw0YSVx
	3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHNYNksK2J6Nmyg+w6bHaKLm2qeeByLlv9YecKn6
	8+uGV3hsjqhondxOW9u5Rzx8VA8sFT8axXsxnU+H+2iaxTrlJfWnTqsr5zCY8r+PXJp47UGT
	mU7nFpXvW5iCLhaGHFul6LPVweivKrf+88u9URuDl6slVx7ud2xs+5S65+q1Y3feztxtrsRS
	nJFoqMVcVJwIAKfurqH3AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 549d820..e18f95b 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -39,7 +39,7 @@
  * @chan:		iio channel being queried.
  */
 struct adc_jack_data {
-	struct extcon_dev edev;
+	struct extcon_dev *edev;
 
 	const char **cable_names;
 	int num_cables;
@@ -64,7 +64,7 @@ static void adc_jack_handler(struct work_struct *work)
 
 	ret = iio_read_channel_raw(data->chan, &adc_val);
 	if (ret < 0) {
-		dev_err(&data->edev.dev, "read channel() error: %d\n", ret);
+		dev_err(&data->edev->dev, "read channel() error: %d\n", ret);
 		return;
 	}
 
@@ -80,7 +80,7 @@ static void adc_jack_handler(struct work_struct *work)
 	}
 	/* if no def has met, it means state = 0 (no cables attached) */
 
-	extcon_set_state(&data->edev, state);
+	extcon_set_state(data->edev, state);
 }
 
 static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
@@ -102,18 +102,21 @@ static int adc_jack_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	data->edev.name = pdata->name;
-
 	if (!pdata->cable_names) {
 		dev_err(&pdev->dev, "error: cable_names not defined.\n");
 		return -EINVAL;
 	}
 
-	data->edev.dev.parent = &pdev->dev;
-	data->edev.supported_cable = pdata->cable_names;
+	data->edev = devm_extcon_dev_allocate(&pdev->dev, pdata->cable_names);
+	if (IS_ERR(data->edev)) {
+		dev_err(&pdev->dev, "failed to allocate extcon device\n");
+		return -ENOMEM;
+	}
+	data->edev->dev.parent = &pdev->dev;
+	data->edev->name = pdata->name;
 
 	/* Check the length of array and set num_cables */
-	for (i = 0; data->edev.supported_cable[i]; i++)
+	for (i = 0; data->edev->supported_cable[i]; i++)
 		;
 	if (i == 0 || i > SUPPORTED_CABLE_MAX) {
 		dev_err(&pdev->dev, "error: pdata->cable_names size = %d\n",
@@ -144,7 +147,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	err = devm_extcon_dev_register(&pdev->dev, &data->edev);
+	err = devm_extcon_dev_register(&pdev->dev, data->edev);
 	if (err)
 		return err;
 
-- 
1.8.0

