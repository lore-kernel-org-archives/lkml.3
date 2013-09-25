Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3IYINJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:13:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3IYING (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:13:06 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-7e-52429b11f52f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 18/20] regulator: tps6524x: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:13:04 +0900
Message-id: <001b01ceb9c7$0f759e40$2e60dac0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAA1Tww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI13B2U5BBgu+8VscmfOV2WLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX3aPtZ5rFpVSebR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGVcv36ApeAYR8XSi2vZGhi/snUxcnJICJhIXO18zw5hi0lcuLceKM7FISSwjFHiTvcH
	Rpiiiee/sYLYQgLTGSUWbbOGKPrFKLH+1C6wbjYBNYkvXw4D2RwcIgKqEv9fuYPUMAv0M0pc
	2nmHCaLZVmL539ssIDangJ3Esnufwa4QFvCUmHH8EtgyFqDeB11NYDN5ger3Tp7IAmELSvyY
	fA/MZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCSWr1/MClEiIrHvxTtGkHskBG6x
	S0w6v44FYpeAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0ImO94sTc4tK8dL3k/NxNjJA47d/BePeA9SHGZKD1E5mlRJPzgXGeVxJvaGxmZGFq
	YmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGj1ePligoPlh3fLLL
	Od/TTorHUxKO7VCYP1Ntybx3KTwf7ASXTrmU6V/M+lv/7LGznc0BEeJSmd+5X0iYn1kzh/fV
	pxdfs74alexJMODZn7z0rdfXfcrvV96M/tQmpOTslnrl9tz+jBen6q7bPQjdGlV0I0l5r6Nj
	u2Mvh/7Bub77iz6u7lOTVWIpzkg01GIuKk4EAKyur2fpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3B2U5BBt+X81gcmfOV2WLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX3aPtZ5rFpVSebR9+WVYwenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXL9+gKXgGEfF0otr2RoYv7J1MXJySAiYSEw8
	/40VwhaTuHBvPVhcSGA6o8SibdZdjFxA9i9GifWndrGDJNgE1CS+fDkMZHNwiAioSvx/5Q5S
	wyzQzyhxaecdJohmW4nlf2+zgNicAnYSy+59BhsqLOApMeP4JUYQmwWo90FXE9hMXqD6vZMn
	skDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJ5esXs0KUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAs+kdzCu
	arA4xCjAwajEwytw1DFIiDWxrLgy9xCjBAezkgiv8wynICHelMTKqtSi/Pii0pzU4kOMyUCP
	TmSWEk3OByaovJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	nHj7cMerxozWGS8dv5fVFbWVs4fuX2Sexf5txuKgPrfwysm6Lc1b0yUm7q+eVrVTZ/EP0elP
	DjSs+sPAsy3iooq9m4fO2eu1uifePNyQwtmjwxame0H26bXHny6dTF9y+HBc06Q791gYU92f
	nixO7ePdXVMSHHWCI3aPlpjhH16ZTXK7vHq/K7EUZyQaajEXFScCAALixuZGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps6524x-regulator.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..8fe67fb 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -584,10 +584,8 @@ static int pmic_remove(struct spi_device *spi)
 
 	if (!hw)
 		return 0;
-	for (i = 0; i < N_REGULATORS; i++) {
-		regulator_unregister(hw->rdev[i]);
+	for (i = 0; i < N_REGULATORS; i++)
 		hw->rdev[i] = NULL;
-	}
 	return 0;
 }
 
@@ -631,7 +629,8 @@ static int pmic_probe(struct spi_device *spi)
 		config.init_data = init_data;
 		config.driver_data = hw;
 
-		hw->rdev[i] = regulator_register(&hw->desc[i], &config);
+		hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
+						      &config);
 		if (IS_ERR(hw->rdev[i])) {
 			ret = PTR_ERR(hw->rdev[i]);
 			hw->rdev[i] = NULL;
-- 
1.7.10.4


