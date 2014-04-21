Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaDUMC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:02:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaDUMCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:23 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-82-535508cd31fb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 8/9] extcon: adc-jack: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:21 +0900
Message-id: <1398081742-24277-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSonuWIzTYYPMXJYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2P2rSusBR3CFRMX/WJtYLzE38XI
	ySEhYCJx7NMLFghbTOLCvfVsXYxcHEICSxklejZeZoIputt+kBUisYhRYunst0wQThOTxOH7
	O1hBqtgEtCT2v7jBBmKLCChIbO59BtbBLPCMUeLE1RPMIAlhgTCJRQvegY1lEVCV+DTpC5jN
	K+Aqsen/BDaIdXISH/Y8Yu9i5ODgFHCTuHCiHCQsBFTy6PdmRpCZEgK72CUOvJsDNUdA4tvk
	Qywg9RICshKbDjBDjJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQJj
	4fS/Z/07GO8esD7EmAw0biKzlGhyPjCW8kriDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY210+oZfwVPvSIv87knVf8oQd/7OsvBFpVt1LrLOnsHx
	JpLr8vyrNrN+nls35bV3XaDFgfmCRuE+Z+YLa16QX/VHKVRdak4Vt7nH5wLGpJlNumc23Wd9
	8qd1ocHOYjemPfnCrg0rQ1TEWm4K20RVnntaxsv6UUK3QStU/oV0xrpHGkvn9+9QVWIpzkg0
	1GIuKk4EAEYC54qbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd2zHKHBBhMfSVkcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzZt+6wlrQIVwxcdEv1gbGS/xdjJwcEgImEnfbD7JC2GISF+6tZ+ti5OIQEljEKLF09lsm
	CKeJSeLw/R1gVWwCWhL7X9xgA7FFBBQkNvc+YwUpYhZ4xihx4uoJZpCEsECYxKIF75hAbBYB
	VYlPk76A2bwCrhKb/k9gg1gnJ/FhzyP2LkYODk4BN4kLJ8pBwkJAJY9+b2acwMi7gJFhFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwpD2T3sG4qsHiEKMAB6MSD++L/JBgIdbEsuLK3EOM
	EhzMSiK8EeuBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPTAJ5JfGGxiZmRpZG5oYWRsbm
	pAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDYIhHn9/L3iw1mj3q5XE22y63758V0p97z
	gMm5xjZZzb6PSkYmOYZqb7MZVko5a4h3Mn1x4loxa0JkqEqn/5GcO8xxlWeUXwgphrncZro3
	5YB20yZ2871Oz5R6arWZ/woWWj1LauLdnr7gRJW8SNCi8D+HM2feL9WZfu38/tP3n82a/tbg
	9WslluKMREMt5qLiRACI/BAp+AIAAA==
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
index 549d820..fd3bc661 100644
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
 		dev_err(&pdev->dev, "error: pdata->cable_names size = %d\n",
@@ -144,7 +147,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	err = devm_extcon_dev_register(&pdev->dev, &data->edev);
+	err = devm_extcon_dev_register(&pdev->dev, data->edev);
 	if (err)
 		return err;
 
-- 
1.8.0

