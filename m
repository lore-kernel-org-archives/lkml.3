Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3IZCNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:13:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45049 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3IZCNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:13:08 -0400
X-AuditID: cbfee68e-b7f756d000004512-66-5243983350f3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 17/18] regulator: twl: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:13:06 +0900
Message-id: <001701ceba5d$f0827750$d18765f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAWzIQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zI13jGc5BBh0fuCymTt7OZjH14RM2
	i8sLL7FafLvSwWRxedccNos3P84yObB57Jx1l91j06pONo++LasYPY7f2M7k8XmTXABrFJdN
	SmpOZllqkb5dAldG137pgoscFd+77zE3MC5j72Lk5JAQMJG4+vMxC4QtJnHh3nq2LkYuDiGB
	ZYwSW750scEUbb5ykBEisYhRYuvHJqiqX4wSi/9+BKtiE1CT+PLlMNBYDg4RAVWJ/6/cQcLM
	AmsZJeZ0e4PYQgK2Eqd+XwQr5xSwkzh9bSMrSLmwgLvEwlcRIGEWoM7mFRNZQMK8IOVXtUDC
	vAKCEj8m32OBmKglsX7ncSYIW15i85q3zCDlEgLqEo/+6oKERQSMJG7tfwxVIiKx78U7sOsl
	BO6xS/Qvn8MCsUpA4tvkQywQvbISmw4wQ3wrKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUV
	o2hqQXJBcVJ6kZFecWJucWleul5yfu4mRki09u1gvHnA+hBjMtD6icxSosn5wGjPK4k3NDYz
	sjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj0cn8ZVp3GbnV
	fDzDhE0XdE427/P48UqunbF1lqvflfQJMUeliu5+2qq0MH1t6s5CY0Wv4t/BL4IkJ7XP/3Rb
	X6Jt7cJ3be+XnJzrKldr6vF1HqOC4A05+2xLoV9enLWzdOYptWkff9fC1ptw+LHr34M1suYc
	CmFGcwOv+NmdNdi81qijyVSJpTgj0VCLuag4EQDQnjJC7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3jGc5BBm/72S2mTt7OZjH14RM2
	i8sLL7FafLvSwWRxedccNos3P84yObB57Jx1l91j06pONo++LasYPY7f2M7k8XmTXABrVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjK790gUXOSq+d99jbmBcxt7FyMkh
	IWAisfnKQUYIW0ziwr31bF2MXBxCAosYJbZ+bIJyfjFKLP77kQ2kik1ATeLLl8NA3RwcIgKq
	Ev9fuYOEmQXWMkrM6fYGsYUEbCVO/b4IVs4pYCdx+tpGVpByYQF3iYWvIkDCLECdzSsmsoCE
	eUHKr2qBhHkFBCV+TL7HAjFRS2L9zuNMELa8xOY1b5lByiUE1CUe/dUFCYsIGEnc2v8YqkRE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCp4
	Jr2DcVWDxSFGAQ5GJR7eC8zOQUKsiWXFlbmHGCU4mJVEeL8ZAYV4UxIrq1KL8uOLSnNSiw8x
	JgP9OZFZSjQ5H5im8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBUcvSrtjqOKuml8zqwl0lQvNn2i6e82GPA1uL5CRFmQfzmQPzky0W1M57eNq4csU7zR95
	qisKDvnetZp7W1yE8eutFyybDkR56nw9m9HnINaw9dSU6mDODa2ma/p4ZFJ+fp31dNUcnUln
	X2YFSpZ8vrI069x3t6Lpxb62EadXtFaeN78cx8F4X4mlOCPRUIu5qDgRAJ+X2RRJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/twl-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 78aae4c..8ebd785 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1188,7 +1188,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	config.driver_data = info;
 	config.of_node = pdev->dev.of_node;
 
-	rdev = regulator_register(&info->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
@@ -1217,7 +1217,6 @@ static int twlreg_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct twlreg_info *info = rdev->reg_data;
 
-	regulator_unregister(rdev);
 	kfree(info);
 	return 0;
 }
-- 
1.7.10.4


