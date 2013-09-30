Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3I3A4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:56:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3I3A4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:56:30 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-21-5248cc38d219
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 08/14] regulator: max8925: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:56:24 +0900
Message-id: <007b01cebd77$e2dc7660$a8956320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAMoQw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ12LMx5BBvM6jS2mPnzCZnH53GFG
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DKuLvtHnPBFO6KOY1TWBoYl3N2MXJySAiYSMze/pQdwhaTuHBvPRuILSSwjFHi5kpZ
	mJqlr98BxbmA4tMZJdo3/2eFcH4xSvxvfMECUsUmoCbx5cthoEkcHCICqhL/X7mD1DALzGWU
	mLa4iR1iqq3EnPNnGUFsTgE7iTsbWsFsYQFviYWnrrCC2CxAvR3z1jOD2LxA9VeWL2SDsAUl
	fky+B7aLWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwkji4cx4bRImIxL4X7xhB7pEQ
	uMcuMX/+b6hdAhLfJh9igeiVldh0gBniYUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0otM9YoTc4tL89L1kvNzNzFCInXiDsb7B6wPMSYDrZ/ILCWanA+M9LySeENjMyML
	UxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MO7jdl3431nrvt3r
	uvKrQec8+kPc2x7FXb9YvWKK9caFj1nLX6jVXU1aIuqjOeXPQ+WgA2sstjzpM3vb5iMurfZN
	KPfJCfvyxXXeWZMzNL7Yf364c+uupe+auQ4o/D/4VrnAwX/zb9uMTxYMAhX88r/XHKlpiP7/
	TlqX3eF5nnHafSGtU8b8GkosxRmJhlrMRcWJADJCB4nqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV2LMx5BBuu361tMffiEzeLyucOM
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHF32z3mgincFXMap7A0MC7n7GLk5JAQMJFY
	+vodG4QtJnHh3nogm4tDSGA6o0T75v+sEM4vRon/jS9YQKrYBNQkvnw5zN7FyMEhIqAq8f+V
	O0gNs8BcRolpi5vYQWqEBGwl5pw/ywhicwrYSdzZ0ApmCwt4Syw8dYUVxGYB6u2Yt54ZxOYF
	qr+yfCEbhC0o8WPyPbBdzAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcTBnfPYIEpE
	JPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeC
	Z1I7GFc2WBxiFOBgVOLhnbDcI0iINbGsuDL3EKMEB7OSCO/yJKAQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wOTVF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBx
	cEo1MNabaXv9ctDzOsPKVvDP0MTAwFG6QdW5rezI/63L8reHs23Y65SaXTWJ5b39kV0rHQvc
	ypWrNvSWu8srRb4VnvzqWEJTb4tWr9bptP19+fLGEjK9bKf+hKWsSQ92lrtbfTk8v2R5yt3X
	NpVeLxdd/23/zrVpPc+7M3GTrSsuFbPtWr3G1XK+EktxRqKhFnNRcSIAI/pu7EgDAAA=
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
 drivers/regulator/max8925-regulator.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index d80b5fa..7595107 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -312,7 +312,7 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 		if (pdata)
 			config.init_data = pdata;
 
-	rdev = regulator_register(&ri->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
@@ -323,22 +323,12 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int max8925_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver max8925_regulator_driver = {
 	.driver		= {
 		.name	= "max8925-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max8925_regulator_probe,
-	.remove		= max8925_regulator_remove,
 };
 
 static int __init max8925_regulator_init(void)
-- 
1.7.10.4


