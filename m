Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaDXMnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:43:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45064 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbaDXMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:35:00 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-02-535904f0b6f0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 7/9] extcon: adc-jack: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:55 +0900
Message-id: <1398342897-23670-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSpPuRJTLY4M5VVouD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2P2rSusBR3CFRMX/WJtYLzE38XI
	ySEhYCLRN2s/E4QtJnHh3nq2LkYuDiGBpYwSf2YuYocpWvTtGVRiOqPE602LwDqEBJqYJKZv
	NwSx2QS0JPa/uMEGYosIKEhs7n3GCtLALPCMUeLE1RPMIAlhgTCJ5dfPgk1lEVCVeHivDWwQ
	r4CrxPzvz1kgtslJfNjzCKyGU8BN4uyFq2wQy1wlVjb8AxsqIbCNXaLr9WU2iEECEt8mHwJq
	5gBKyEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMhdP/
	nk3cwXj/gPUhxmSgcROZpUST84GxlFcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjDUzyw8UOk8/fa6133KLbqMg0x62pM9aL7i2rw7atNLEPN5k
	W0p2hOGGTc5qbrOXevK+sn/2Rj/14U293uk62z+tt5d77ZzqfDfhFDdjct0k++0z50TIPjE7
	c17pdLOZt7P9/w/n5Q+0aXoo/K7Oy2Tx8wzl/Hn92JIGv8la57pEOfbkTq8oUGIpzkg01GIu
	Kk4EACAQ4ZubAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd0PLJHBBtP2W1kcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzZt+6wlrQIVwxcdEv1gbGS/xdjJwcEgImEou+PWODsMUkLtxbD2RzcQgJTGeUeL1pERNI
	QkigiUli+nZDEJtNQEti/4sbYA0iAgoSm3ufsYI0MAs8Y5Q4cfUEM0hCWCBMYvn1s+wgNouA
	qsTDe21gg3gFXCXmf3/OArFNTuLDnkdgNZwCbhJnL1xlg1jmKrGy4R/rBEbeBYwMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCI+2Z1A7GlQ0WhxgFOBiVeHgPXAgPFmJNLCuuzD3EKMHB
	rCTCO/tfRLAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wOTQF5JvKGxiZmRpZG5oYWRsTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MGYqNXu+zDgzVebMR70z2/Q45jxayX/uTv2s
	+dM/8is/rOQ6OsfwypHqG44Zlhc4zHaamaWtuS7bVmaw3FAp/oqr+o+UwzrTXP+58+y92/3J
	8XlPbKNMvUpk5iQp22iN9MD+STZz7hm3KvxJ2MQpWTFt5i/v33fu9PGXmPy9yndmG6uM3jHr
	pUosxRmJhlrMRcWJAIyIKRD4AgAA
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

