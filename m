Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaDUJhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaDUJga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:30 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ad-5354e6997d8c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 8/9] extcon: adc-jack: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 18:36:25 +0900
Message-id: <1398072986-17386-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSojvzWUiwwbX3ZhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZhxdeZCuYIFaxa80PlgbG
	bqEuRk4OCQETiWnb/7JA2GISF+6tZ+ti5OIQEljKKLHv2ydmmKKGqfsZIRKLGCXeLbvHDOE0
	MUm0vb3HDlLFJqAlsf/FDTYQW0RAQWJz7zNWkCJmgQYmiTmfFjCBJIQFQiR23DgFVsQioCrR
	uWg2mM0r4CoxZ/9cqHVyEh/2PAIbyingJrHuRzcriC0EVNPxvo8RomYfu8SePwEQcwQkvk0+
	BPQDB1BcVmLTAagxkhIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYEyc
	/vesdwfj7QPWhxiTgcZNZJYSTc4HxlReSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTBy2x7o3Px+ftMUniPdixrrjd5cDD/Xx/M3xT7wx9lvpbrJ
	s78lX90dpsbju/LNnq2PNV5by8/pWvXvvL1dYH6KwIXFM3QfPTT8kqR5/OOdG9fa2Ky8NTJF
	5pQee3J2fUBbxZNfqYUpS0TPn6mVC5130CKg4gBD+LtDHAzxGd9sL7i7svbkvJuuxFKckWio
	xVxUnAgA1LKN058CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd2Zz0KCDbY817c4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmHF44UW2ggliFbvW/GBpYOwW6mLk5JAQMJFomLqfEcIWk7hwbz1bFyMXh5DAIkaJ
	d8vuMUM4TUwSbW/vsYNUsQloSex/cYMNxBYRUJDY3PuMFaSIWaCBSWLOpwVMIAlhgRCJHTdO
	gRWxCKhKdC6aDWbzCrhKzNk/lxlinZzEhz2PwIZyCrhJrPvRzQpiCwHVdLzvY5zAyLuAkWEV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDMPZPewbiqweIQowAHoxIP74v8kGAh1sSy4src
	Q4wSHMxKIrwR64FCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA9MB3kl8YbGJmZGlkbmhhZG
	xuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDgj6Of7LBWh+daGJVO/P64V4t2jsKR3
	+f9d6x6df6SwePZs1bm2Dy0NBKO19625GlNtuED660t1WXvLZOFsoc13vmyumhZ3sYV77q6P
	Bztn7WW7pOZwR3zR6VMFKovLBOaZ9N0PMnuctXnxSp5Jqz5u7fOdMzfQ8NaNuE+ZLy4cLwlU
	qtF6E7tUiaU4I9FQi7moOBEAVqzSKv0CAAA=
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
 drivers/extcon/extcon-adc-jack.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index e23f1c2..56dcf58 100644
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
@@ -102,19 +102,22 @@ static int adc_jack_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	data->edev.name = pdata->name;
-
 	if (!pdata->cable_names) {
 		err = -EINVAL;
 		dev_err(&pdev->dev, "error: cable_names not defined.\n");
 		goto out;
 	}
 
-	data->edev.dev.parent = &pdev->dev;
-	data->edev.supported_cable = pdata->cable_names;
+	data->edev = devm_extcon_dev_allocate(&pdev->dev, pdata->cable_names);
+	if (!data->edev) {
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
 		err = -EINVAL;
@@ -149,7 +152,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	err = extcon_dev_register(&data->edev);
+	err = extcon_dev_register(data->edev);
 	if (err)
 		goto out;
 
@@ -171,7 +174,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 	return 0;
 
 err_irq:
-	extcon_dev_unregister(&data->edev);
+	extcon_dev_unregister(data->edev);
 out:
 	return err;
 }
@@ -182,7 +185,7 @@ static int adc_jack_remove(struct platform_device *pdev)
 
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
-	extcon_dev_unregister(&data->edev);
+	extcon_dev_unregister(data->edev);
 
 	return 0;
 }
-- 
1.8.0

