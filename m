Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3IYIAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:00:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64274 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:00:07 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-ce-52429806c07f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 07/20] regulator: gpio-regulator: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:00:05 +0900
Message-id: <001001ceb9c5$3f2d91d0$bd88b570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAVupg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zI122GU5BBs9PsVocmfOV2WLqwyds
	Fv8fvWa1uLzwEqvFtysdTBaXd81hc2Dz2DnrLrtH288yj02rOtk8+rasYvTYfm0es8fnTXIB
	bFFcNimpOZllqUX6dglcGRdnTWYv+MtR8WXZHtYGxjPsXYycHBICJhJTLn9ghLDFJC7cW8/W
	xcjFISSwjFFi59JFLDBFc2ZeYYFILGKU+Hr+HhtIQkjgF6PElImSIDabgJrEly+HgaZycIgI
	qEr8f+UOUs8ssJVRYsukk+wQ9bYSy//eBhvKKWAnsezeZ7A5wgL+EtO2nmAG6WUB6p39LxAk
	zAtUPmUjxHG8AoISPybfA2tlFtCSWL/zOBOELS+xec1bsFYJAXWJR391QcIiAkYSZ47PYoco
	EZHY9+IdI8g5EgJv2SWeLn4CNodFQEDi2+RDLBC9shKbDjBDvCspcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGSOT27mC8fcD6EGMy0PqJzFKi
	yfnAyM8riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A+MkGeVr2TLvc+L/L17B9XDnrZmspiwmUYwvY3SMA6Y3rdvNsuBK6vxVQsbfbZZKXN1QtZvh
	wIl3LzYtXpr8PIPhk1rHnnyzeU+i/lgrdK2JqP2xpC9nWexE1m9TF59I00y4XsTKIiWwQIlr
	n4q6106nORP/lVYe3lzx5sn5R57fwl0sew0zF7EosRRnJBpqMRcVJwIAccKUhPICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV22GU5BBssOMVocmfOV2WLqwyds
	Fv8fvWa1uLzwEqvFtysdTBaXd81hc2Dz2DnrLrtH288yj02rOtk8+rasYvTYfm0es8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMuzprMXvCXo+LLsj2sDYxn
	2LsYOTkkBEwk5sy8wgJhi0lcuLeerYuRi0NIYBGjxNfz99hAEkICvxglpkyUBLHZBNQkvnw5
	DNTMwSEioCrx/5U7SD2zwFZGiS2TTrJD1NtKLP97G2wop4CdxLJ7n8HmCAv4S0zbeoIZpJcF
	qHf2v0CQMC9Q+ZSNHxghbEGJH5PvgbUyC2hJrN95nAnClpfYvOYtWKuEgLrEo7+6IGERASOJ
	M8dnsUOUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAhOC8+kdjCubLA4xCjAwajEwytw1DFIiDWxrLgy9xCjBAezkghv0VSnICHelMTKqtSi
	/Pii0pzU4kOMyUB/TmSWEk3OB6asvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGan
	phakFsFsYeLglGpgbDba7nrG+3bC6oCcec+yT/1LOsvi8K5KRpj5wZr5U7zSFcsXB0/nU+Jx
	yd61lkm9UD9wc87xZYeuenXqm9xIFE6QW224L6klYMnZjMKMpMmTkza2vWe0PDRJdJ0tz+n+
	/b+/bnvAIzk3TmOh80GuvZ8+sZ6N2/Fi3qGXJwu6LqUpp7h8fetUpcRSnJFoqMVcVJwIADld
	cgpPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/gpio-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 98a98ff..92aaec6 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -322,7 +322,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 	}
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -349,8 +350,6 @@ static int gpio_regulator_remove(struct platform_device *pdev)
 {
 	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
-
 	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
 
 	kfree(drvdata->states);
-- 
1.7.10.4


