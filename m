Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3I3A6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:58:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3A6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:58:37 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-e4-5248ccbc1165
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 12/14] regulator: tps6524x: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:58:36 +0900
Message-id: <007f01cebd78$31657160$94305420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAARPGw
Content-language: ko
x-cr-hashedpuzzle: FAGU LKlS L4Bi L+F1 M/v7 eY08 e+HJ fHYw gfCQ gtVX hITx sL2V
 tyS4 yO+N 3agE
 558X;5;YQB4AGUAbAAuAGwAaQBuAEAAaQBuAGcAaQBjAHMALgBjAG8AbQA7AGIAcgBvAG8AbgBpAGUAQABrAGUAcgBuAGUAbAAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAZwBpAHIAZAB3AG8AbwBkAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{4E4865BA-130D-4476-AF13-8D99B8E48DE1};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 30 Sep 2013 00:58:27
 GMT;WwBQAEEAVABDAEgAIABWADQAIAAxADIALwAxADQAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIAB0AHAAcwA2ADUAMgA0AHgAOgAgAHUAcwBlACAAZABlAHYAbQBfAHIAZQBnAHUAbABhAHQAbwByAF8AcgBlAGcAaQBzAHQAZQByACgAKQA=
x-cr-puzzleid: {4E4865BA-130D-4476-AF13-8D99B8E48DE1}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zI909ZzyCDNq7VC2OzPnKbDH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7tP0s89i0qpPNo2/LKkaPz5vkAlijuGxSUnMyy1KL
	9O0SuDJubP/EWHCTv+L1K9EGxtM8XYycHBICJhKdX5+zQthiEhfurWfrYuTiEBJYxihx8eJi
	Vpiizzfns0MkFjFKzHz4gRHC+cUosebsTnaQKjYBNYkvXw4D2RwcIgKqEv9fuYPUMAv0M0pc
	2nmHCaRGSMBWYs75s4wgNqeAncSdDa1gtrCAj8TzzXPYQGwWoN5/N9rAbF6g+tWNDUwQtqDE
	j8n3WEBsZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASGJn60FmiBIRiX0v3oHdLCFw
	glXi6M8vjBCfmUocvjmTBSLxk11ic1sDC8QRAhLfJh9igRgqK7HpADNEvaTEwRU3WCYwSs1C
	ctIsJCfNQnLSLCS7FzCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiewJOxjvHbA+xJgM
	tH4is5Rocj4wMeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgZFF99rRyOyFS5lWVvrtVqnK3KF5f378Av6/Z6W3HQucFzZnZrVX9fJfkvpvQqN5
	4kMOLYu3UVTUVfLKOeOz6va5s2Y5M42LGxp7Texir7IoGwTeb+++Z+C9kf9Bx52K05aOcQFb
	XgQoXH+zccUyoX3TL2xnF5eKqloczF68in3pFv6LonOv5CqxFGckGmoxFxUnAgAACtbbAgMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd09ZzyCDK6+UbA4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvu0fazzGPTqk42j74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuLH9E2PBTf6K169EGxhP83QxcnJICJhIfL45
	nx3CFpO4cG89WxcjF4eQwCJGiZkPPzBCOL8YJdac3QlWxSagJvHly2Egm4NDREBV4v8rd5Aa
	ZoF+RolLO+8wgdQICdhKzDl/lhHE5hSwk7izoRXMFhbwkXi+eQ4biM0C1PvvRhuYzQtUv7qx
	gQnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSexsPcgMUSIise/F
	O7CbJQROsEoc/fmFEeIzU4nDN2eyTGAUmYVkxSwkK2YhWTELyawFjCyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYLTxjPpHYyrGiwOMQpwMCrx8Fos9QgSYk0sK67MPcQowcGsJMK7PAko
	xJuSWFmVWpQfX1Sak1p8iDEZGAITmaVEk/OBKS2vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhj9XZJsjkh8FQjavu5LfnBwSagnG8OM3H0BNRPU3q9d/75H
	aG7R1885Ptn/DK5kvRYxzW95s0JR64NqubSDzCLXUIVpKyT+zLWeyT5F66WA1dI6aXn5lJ3V
	C+WnG/CELd6fbGkZtf3Y9sNLbnS/tNsu+1n508tG27LY8xGfKpeEMPgsrKuQDFdiKc5INNRi
	LipOBABdDp+5XwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6524x-regulator.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..9f6bfda 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -577,20 +577,6 @@ static struct regulator_ops regulator_ops = {
 	.get_current_limit	= get_current_limit,
 };
 
-static int pmic_remove(struct spi_device *spi)
-{
-	struct tps6524x *hw = spi_get_drvdata(spi);
-	int i;
-
-	if (!hw)
-		return 0;
-	for (i = 0; i < N_REGULATORS; i++) {
-		regulator_unregister(hw->rdev[i]);
-		hw->rdev[i] = NULL;
-	}
-	return 0;
-}
-
 static int pmic_probe(struct spi_device *spi)
 {
 	struct tps6524x *hw;
@@ -598,7 +584,7 @@ static int pmic_probe(struct spi_device *spi)
 	const struct supply_info *info = supply_info;
 	struct regulator_init_data *init_data;
 	struct regulator_config config = { };
-	int ret = 0, i;
+	int i;
 
 	init_data = dev_get_platdata(dev);
 	if (!init_data) {
@@ -631,24 +617,17 @@ static int pmic_probe(struct spi_device *spi)
 		config.init_data = init_data;
 		config.driver_data = hw;
 
-		hw->rdev[i] = regulator_register(&hw->desc[i], &config);
-		if (IS_ERR(hw->rdev[i])) {
-			ret = PTR_ERR(hw->rdev[i]);
-			hw->rdev[i] = NULL;
-			goto fail;
-		}
+		hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
+						      &config);
+		if (IS_ERR(hw->rdev[i]))
+			return PTR_ERR(hw->rdev[i]);
 	}
 
 	return 0;
-
-fail:
-	pmic_remove(spi);
-	return ret;
 }
 
 static struct spi_driver pmic_driver = {
 	.probe		= pmic_probe,
-	.remove		= pmic_remove,
 	.driver		= {
 		.name	= "tps6524x",
 		.owner	= THIS_MODULE,
-- 
1.7.10.4


