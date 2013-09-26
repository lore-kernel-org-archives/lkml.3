Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3IZCKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:10:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22131 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3IZCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:10:23 -0400
X-AuditID: cbfee68e-b7f756d000004512-92-5243978e4b94
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 12/18] regulator: max8952: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:10:22 +0900
Message-id: <001201ceba5d$8e3f48c0$aabdda40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAQ3kg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA92+6c5BBsuniVhMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsWHfU9aCPxwVn6bNYmpgPMfexcjJISFgIrHu6x4oW0ziwr31bCC2kMAyRom/81Jg
	aq59+sTUxcgFFJ/OKDH7ywx2COcXo8Sa5R/AutkE1CS+fDkMZHNwiAioSvx/5Q5SwyzQzShx
	ddlndoipthKnfl8E28ApYCdx+tpGVhBbWMBbortlJVgNC1DvomtnwOK8QPUbV25lgbAFJX5M
	vgdmMwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhLPnpyEKheR2PfiHSPIPRICt9gl
	bl5/wwaxS0Di2+RDLBC9shKbDjBDPCwpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpB
	ckFxUnqRkV5xYm5xaV66XnJ+7iZGSKT27WC8ecD6EGMy0PqJzFKiyfnASM8riTc0NjOyMDUx
	NTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+N6xrzDvTWB7j+qb0nI
	5x+9tfVNdaaYuVWQDt89JQFGzXOdKfJqIUnX11r/3mhy2PHdmytyse5V4UxmX3mv33mpXZrf
	7itst7fnNvNNKxvLAF5/M+HiZPdPWgVHmE6H3xY5o3CVo2VOkN3sUKWIMiHXo9vYK69HMiS4
	sN/arKG8em37dIYFSizFGYmGWsxFxYkAfRlwnOoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2+6c5BBu/vCFhMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFh31PWgj8cFZ+mzWJqYDzH3sXIySEhYCJx
	7dMnJghbTOLCvfVsXYxcHEIC0xklZn+ZwQ7h/GKUWLP8A1gHm4CaxJcvh4FsDg4RAVWJ/6/c
	QWqYBboZJa4u+wxWIyRgK3Hq90U2EJtTwE7i9LWNrCC2sIC3RHfLSrAaFqDeRdfOgMV5geo3
	rtzKAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCSePTkJVS4ise/F
	O8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOBE8k9rB
	uLLB4hCjAAejEg/vBWbnICHWxLLiytxDjBIczEoivN+MgEK8KYmVValF+fFFpTmpxYcYk4Ee
	ncgsJZqcD0xSeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	yN176/ixqT9upS+9cvvpMZcv7HyLfZV2l/+6XpJqK2Pz3bB8aa+B7gux9+reJ4QK67e56e9c
	9nyeFUdx66x5Wj0p/UvOXf7QKTeT+Z7VIo/Df3IW8x99c9u04E/U/dudvEsmZT25faDB1rl0
	z9I+htcN5nK3FT5PuXKYLdrsgm87j3XNzXdX9ZRYijMSDbWYi4oTAXdmsKFIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/max8952.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 788e5ae..6fb7ec1 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -231,7 +231,8 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	if (pdata->reg_data->constraints.boot_on)
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
-	max8952->rdev = regulator_register(&regulator, &config);
+	max8952->rdev = devm_regulator_register(&client->dev, &regulator,
+						&config);
 
 	if (IS_ERR(max8952->rdev)) {
 		ret = PTR_ERR(max8952->rdev);
@@ -321,9 +322,6 @@ static int max8952_pmic_remove(struct i2c_client *client)
 {
 	struct max8952_data *max8952 = i2c_get_clientdata(client);
 	struct max8952_platform_data *pdata = max8952->pdata;
-	struct regulator_dev *rdev = max8952->rdev;
-
-	regulator_unregister(rdev);
 
 	gpio_free(pdata->gpio_vid0);
 	gpio_free(pdata->gpio_vid1);
-- 
1.7.10.4


