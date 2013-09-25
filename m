Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3IYICe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:02:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65157 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3IYICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:02:31 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-57-5242989622b3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 09/20] regulator: lp3972: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:02:30 +0900
Message-id: <001201ceb9c5$95268ab0$bf73a010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAduyw
Content-language: ko
x-cr-hashedpuzzle: Hg14 I/Hr LLyt Q09j R8j1 R+6z SWZg UhyF UrS1 dK8q ixZj jSkI
 oPXv v39D 3iEo
 4E19;5;YgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABnAGkAcgBkAHcAbwBvAGQAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAC4AcwB6AHkAcAByAG8AdwBzAGsAaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Sosha1_v1;7;{5F054DAE-1BB0-4566-81B3-3AB727C0A677};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 25 Sep 2013 08:02:21
 GMT;WwBQAEEAVABDAEgAIAAwADkALwAyADAAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABsAHAAMwA5ADcAMgA6ACAAdQBzAGUAIABkAGUAdgBtAF8AcgBlAGcAdQBsAGEAdABvAHIAXwByAGUAZwBpAHMAdABlAHIAKAApAA==
x-cr-puzzleid: {5F054DAE-1BB0-4566-81B3-3AB727C0A677}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zQ91pM5yCDFo3CltMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	MhZMm8JcMJW7Yv6PLuYGxl7OLkYODgkBE4m5n5W7GDmBTDGJC/fWs3UxcnEICSxjlDj35zAz
	RMJE4mjfNXaIxCJGidsP3zNCOL8YJTqPL2cFqWITUJP48uUwO8hUEQFVif+v3EFqmAXmMUp8
	+HeeHaRGSMBWYvnf2ywgNqeAncSye5/ZQGxhAXeJrn9TmUB6WYB6T1+WBgnzApU3vjnOBmEL
	SvyYfA+slVlAS2L9zuNMELa8xOY1b5khnlGXePRXFyQsImAkceHtPjaIEhGJfS/eMUL8coJV
	YspEGQjbVOLxs71MIGdKCHxklzh9/hXYwywCAhLfJh9igZgpK7HpADQcJCUOrrjBMoFRahaS
	i2YhuWgWkotmIVm9gJFlFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZINE/YwXjvgPUhxmSg
	9ROZpUST84HJIK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjB2Hb2Y7X/CNbapzYZjNePBjY5rTCav1OtsFThbOTZVeH/XiyzWhFyypDB9UlL5d
	X3a+QOwhx/zf69dKTzJdE3K6NWJhn9V/Fy3x3OYFD42lPm1+fWaWs/xbq7ciEW//fRNgMp+S
	wHCZ64PgKqHoiUKnsw9US6r+qpcqvrNbtyAwTC7I8BXjVyWW4oxEQy3mouJEAPLj6G78AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd1pM5yCDE4f4reY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF2iN32R1YPXbOusvusWlVJ5tH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWYsmDaFuWAqd8X8H13MDYy9nF2MnBwSAiYSR/uusUPY
	YhIX7q1n62Lk4hASWMQocfvhe0YI5xejROfx5awgVWwCahJfvhwG6uDgEBFQlfj/yh2khllg
	HqPEh3/nwSYJCdhKLP97mwXE5hSwk1h27zMbiC0s4C7R9W8qE0gvC1Dv6cvSIGFeoPLGN8fZ
	IGxBiR+T74G1MgtoSazfeZwJwpaX2LzmLTNIq4SAusSjv7ogYREBI4kLb/exQZSISOx78Y4R
	4pcTrBJTJspA2KYSj5/tZZrAKDILyYZZSDbMQrJhFpJRCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEJ4tn0jsYVzVYHGIU4GBU4uEVOOoYJMSaWFZcmXuIUYKDWUmEt2iqU5AQb0pi
	ZVVqUX58UWlOavEhxmSg/ycyS4km5wMTWV5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNIT
	S1KzU1MLUotgtjBxcEo1MPZfUD+c8jc85J4hQ1L9u6f8t8SvcieLfTZMCfJauWPrpYCOG6Zp
	a8Sma6/19XH5nHDuOFvtdY/wIItpB/ruhZVXF+xiYDzT8act52NqgZPiCu+vPOnlq2+H8Hdf
	nST35uiZM2fFnlnV3eC1qnNu2aFtarZpgobvOpW3G7kups35nXeqnGUPqxJLcUaioRZzUXEi
	AOPsMKtaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/lp3972.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 093e6f4..3c18042 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -495,8 +495,9 @@ static int setup_regulators(struct lp3972 *lp3972,
 		config.init_data = reg->initdata;
 		config.driver_data = lp3972;
 
-		lp3972->rdev[i] = regulator_register(&regulators[reg->id],
-						     &config);
+		lp3972->rdev[i] = devm_regulator_register(lp3972->dev,
+							  &regulators[reg->id],
+							  &config);
 		if (IS_ERR(lp3972->rdev[i])) {
 			err = PTR_ERR(lp3972->rdev[i]);
 			dev_err(lp3972->dev, "regulator init failed: %d\n",
@@ -507,8 +508,6 @@ static int setup_regulators(struct lp3972 *lp3972,
 
 	return 0;
 error:
-	while (--i >= 0)
-		regulator_unregister(lp3972->rdev[i]);
 	kfree(lp3972->rdev);
 	lp3972->rdev = NULL;
 err_nomem:
@@ -560,10 +559,7 @@ static int lp3972_i2c_probe(struct i2c_client *i2c,
 static int lp3972_i2c_remove(struct i2c_client *i2c)
 {
 	struct lp3972 *lp3972 = i2c_get_clientdata(i2c);
-	int i;
 
-	for (i = 0; i < lp3972->num_regulators; i++)
-		regulator_unregister(lp3972->rdev[i]);
 	kfree(lp3972->rdev);
 
 	return 0;
-- 
1.7.10.4


