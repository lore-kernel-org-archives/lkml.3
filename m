Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3IZCIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:08:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33301 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3IZCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:08:16 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ac-5243970fb85a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 08/18] regulator: lp872x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:08:14 +0900
Message-id: <000e01ceba5d$427c2480$c7746d80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAMQHQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zY13+6c5BBtf/8FpMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mm681yzoFqxYea6fpYHxLG8XIyeHhICJROfLS0wQtpjEhXvr2boYuTiEBJYxSvTegUmYSOxc
	upARIjGdUeLC7OtQzi9GiWnnWthAqtgE1CS+fDnM3sXIwSEioCrx/5U7SA2zwDxGiQ//zrOD
	1AgJ2Eqc+n0RrJ5TwE7i9LWNrCC2sICXxN0rP5lAelmAencvLgQJ8wKVvzu2mBHCFpT4Mfke
	C4jNLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKERQSMJNZe7maHKBGR2PfiHdjJEgK32CW2
	vr8LtpZFQEDi2+RDLBC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpB
	ckFxUnqRiV5xYm5xaV66XnJ+7iZGSHRO2MF474D1IcZkoPUTmaVEk/OB0Z1XEm9obGZkYWpi
	amxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZHNZelKxVvizXaqiiU
	dZ+2VueYH5+zJSDB1VetsvTym7XxKct/GN/s/Ljs/cEN7zp+p5sGT/Tztn416bnJXclP6xqO
	sxnPfnj7fIhZzZ5sF6ODYQ1bZRY7hyglqS9qOZvJkR50bmb7laOLJptpzNx548Itua8N9fzZ
	Ueo/qgr4zjd27/7054oSS3FGoqEWc1FxIgDdSJNF5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV3+6c5BBm8auSymPnzCZnF54SVW
	i29XOpgsLu+aw2ax9shddgdWj52z7rJ7bFrVyebRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBk33msWdAtWrDzXz9LAeJa3i5GTQ0LARGLn0oWMELaY
	xIV769m6GLk4hASmM0pcmH2dEcL5xSgx7VwLG0gVm4CaxJcvh9m7GDk4RARUJf6/cgepYRaY
	xyjx4d95dpAaIQFbiVO/L4LVcwrYSZy+tpEVxBYW8JK4e+UnE0gvC1Dv7sWFIGFeoPJ3xxYz
	QtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFVCQF3i0V9dkLCIgJHE2svd7BAlIhL7Xrxj
	nMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj/5nUDsaV
	DRaHGAU4GJV4eC8wOwcJsSaWFVfmHmKU4GBWEuH9ZgQU4k1JrKxKLcqPLyrNSS0+xJgM9OdE
	ZinR5HxgWsoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkaR
	pyFF3Y2cB7xfGq6S/5IsMvn6OwG14uVixS9Wbf0/50nc3FNJG3MdpMKzVh/55svTVx7r4HLT
	7bXuRvMrV4JE+cSbL6inCVmxR9xiOLhWZcKPYIe2bY5Xl1msKr9WEXdqTvqcL2r5Lt2K3vOT
	1qT6L5G8OYHzEL8eiztXUkrI31ffeTXen1RiKc5INNRiLipOBACpx+HCQQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/lp872x.c |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2b84b72..2e4734f 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -785,7 +785,7 @@ static int lp872x_regulator_register(struct lp872x *lp)
 	struct regulator_desc *desc;
 	struct regulator_config cfg = { };
 	struct regulator_dev *rdev;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < lp->num_regulators; i++) {
 		desc = (lp->chipid == LP8720) ? &lp8720_regulator_desc[i] :
@@ -796,34 +796,16 @@ static int lp872x_regulator_register(struct lp872x *lp)
 		cfg.driver_data = lp;
 		cfg.regmap = lp->regmap;
 
-		rdev = regulator_register(desc, &cfg);
+		rdev = devm_regulator_register(lp->dev, desc, &cfg);
 		if (IS_ERR(rdev)) {
 			dev_err(lp->dev, "regulator register err");
-			ret =  PTR_ERR(rdev);
-			goto err;
+			return PTR_ERR(rdev);
 		}
 
 		*(lp->regulators + i) = rdev;
 	}
 
 	return 0;
-err:
-	while (--i >= 0) {
-		rdev = *(lp->regulators + i);
-		regulator_unregister(rdev);
-	}
-	return ret;
-}
-
-static void lp872x_regulator_unregister(struct lp872x *lp)
-{
-	struct regulator_dev *rdev;
-	int i;
-
-	for (i = 0; i < lp->num_regulators; i++) {
-		rdev = *(lp->regulators + i);
-		regulator_unregister(rdev);
-	}
 }
 
 static const struct regmap_config lp872x_regmap_config = {
@@ -979,14 +961,6 @@ err_dev:
 	return ret;
 }
 
-static int lp872x_remove(struct i2c_client *cl)
-{
-	struct lp872x *lp = i2c_get_clientdata(cl);
-
-	lp872x_regulator_unregister(lp);
-	return 0;
-}
-
 static const struct of_device_id lp872x_dt_ids[] = {
 	{ .compatible = "ti,lp8720", },
 	{ .compatible = "ti,lp8725", },
@@ -1008,7 +982,6 @@ static struct i2c_driver lp872x_driver = {
 		.of_match_table = of_match_ptr(lp872x_dt_ids),
 	},
 	.probe = lp872x_probe,
-	.remove = lp872x_remove,
 	.id_table = lp872x_ids,
 };
 
-- 
1.7.10.4


