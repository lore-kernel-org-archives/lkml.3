Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3IYIBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:01:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25630 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3IYIBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:01:32 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-d7-5242985b81da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 08/20] regulator: lp3971: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:01:31 +0900
Message-id: <001101ceb9c5$72471500$56d53f00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAailA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zY93oGU5BBgtWWFhMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	MjbNPs9W0MNdseDjdaYGxnbOLkZODgkBE4klvZ+YIWwxiQv31rN1MXJxCAksY5SY1HKPGabo
	4Mx5TBCJ6YwSj86tZ4ZwfjFKvD4/hwWkik1ATeLLl8PsXYwcHCICqhL/X7mD1DALzGOU+PDv
	PDtIjZCArcTyv7fB6jkF7CSW3fvMBmILC7hLrFxyFmwbC1Bv755TjCA2L1D9w4ZDLBC2oMSP
	yffAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEji7+bfbBAlIhL7XrxjBLlHQuAW
	u8SrLXvZIXYJSHybDDIfpFdWYtMBqIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0t
	SC4oTkovMtErTswtLs1L10vOz93ECInQCTsY7x2wPsSYDLR+IrOUaHI+MMLzSuINjc2MLExN
	TI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIljKplmv5Ov4Dcox6
	dre//Kxdu+3j28XqPis25h6R4hEMvx1b1Dx57eE3BzYVJ5zJ2HuVd+v0K34O9X+3qZ2vyQu4
	7v0k5fetjTnsJ23P8vcxbvvV6Mg1k+FPhjhbqNSNa9eCV+97f+lzsWqA9pSHS09mnAh782Tz
	ei5384QZcRE8QRVdCffilViKMxINtZiLihMBeJesq+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd3oGU5BBusPmFhMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDM2zT7PVtDDXbHg43WmBsZ2zi5GTg4JAROJgzPnMUHY
	YhIX7q1n62Lk4hASmM4o8ejcemYI5xejxOvzc1hAqtgE1CS+fDnM3sXIwSEioCrx/5U7SA2z
	wDxGiQ//zrOD1AgJ2Eos/3sbrJ5TwE5i2b3PbCC2sIC7xMolZ5lBbBag3t49pxhBbF6g+ocN
	h1ggbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxN/Nv9kgSkQk9r14
	xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/8z6R2M
	qxosDjEKcDAq8fAKHHUMEmJNLCuuzD3EKMHBrCTCWzTVKUiINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84GpKa8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GKfHbVytv7TTvvzRnWpWM3a3b5JXhFUEYsSylye6XHhYPtU9zmS/x12Hv58PrmTpehMlmHLA
	cPavVWvafn/pU3VRyutmku9YW77xgqeO0efMH5kreQqvzXpyfEr2zg8fT8Y08LdtdtAs99ps
	kbVbvil//ZIJn4wdV/q+XzdFmndr0iOhSGm+BiWW4oxEQy3mouJEADBhsJVDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/lp3971.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 5a4604e..97452a2 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -400,8 +400,9 @@ static int setup_regulators(struct lp3971 *lp3971,
 		config.init_data = reg->initdata;
 		config.driver_data = lp3971;
 
-		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
-						     &config);
+		lp3971->rdev[i] = devm_regulator_register(lp3971->dev,
+							  &regulators[reg->id],
+							  &config);
 		if (IS_ERR(lp3971->rdev[i])) {
 			err = PTR_ERR(lp3971->rdev[i]);
 			dev_err(lp3971->dev, "regulator init failed: %d\n",
@@ -413,8 +414,6 @@ static int setup_regulators(struct lp3971 *lp3971,
 	return 0;
 
 error:
-	while (--i >= 0)
-		regulator_unregister(lp3971->rdev[i]);
 	kfree(lp3971->rdev);
 	lp3971->rdev = NULL;
 err_nomem:
@@ -463,10 +462,6 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 static int lp3971_i2c_remove(struct i2c_client *i2c)
 {
 	struct lp3971 *lp3971 = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < lp3971->num_regulators; i++)
-		regulator_unregister(lp3971->rdev[i]);
 
 	kfree(lp3971->rdev);
 
-- 
1.7.10.4


