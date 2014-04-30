Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbaD3J3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:29:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaD3J2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:28:52 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-a1-5360c2534090
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: [PATCH 4/5 v3] iio: exynos_adc: do a soft reset in case of timeout
Date: Wed, 30 Apr 2014 14:56:54 +0530
Message-id: <1398850015-17761-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSqxt8KCHYYNUrPYuXhzQtzi47yGbR
	vHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MFutnvGZx4PKY3XCRxWPnrLvs
	HvvnrmH3WPLmEKtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZdzrqCv4KVqxaPl31gbGRqEu
	Rk4OCQETiR99XcwQtpjEhXvr2boYuTiEBJYySsy+9JQdpuhc92lWiMR0RokZszeyQzj9TBIP
	v/wDq2ITMJM4uGg1kM3BISIgKzGzWw+khlngCaPEjy2vmUHiwgLeEnPuMYGUswioShy4vgJs
	M6+Aq8TuxTuZQEokBBQk5kyyAQlzCrhJNB9dyAJiCwGVNJ09zARxzz52iV0riyHGCEh8m3yI
	BaJVVmLTAahfJCUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwDg4/e9Z
	3w7GmwesDzEmA42byCwlmpwPjKO8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cAYfVcvujwt+MR+A4WLb9OmsTy/Ec2gLe7pEqH7qej78+Nq5jFT
	W953bfU21/1cvWXZ9v5Oz9TS0Dt8v/uF3bqOTXgtfC261sFojU0G2yx/R6XtG46fFpyaP+9r
	abHy67qyb5sWb4i0ENjwSMPztsovNf/CFQXzVxz7pqWRcvTLkenv+63uvn6vxFKckWioxVxU
	nAgAUlA4bpkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd3gQwnBBq9uqFu8PKRpcXbZQTaL
	5sXr2SxeHfnBZLFk8nxWi3lH3rFYXN41h81ixvl9TBaLtv1ntlg/4zWLA5fH7IaLLB47Z91l
	99g/dw27x5I3h1g9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPGvY66gp+iFYuWf2dtYGwU6mLk5JAQMJE4132aFcIWk7hwbz1bFyMXh5DAdEaJGbM3
	skM4/UwSD7/8YwepYhMwkzi4aDWQzcEhIiArMbNbD6SGWeAJo8SPLa+ZQeLCAt4Sc+4xgZSz
	CKhKHLi+ghnE5hVwldi9eCcTSImEgILEnEk2IGFOATeJ5qMLWUBsIaCSprOHmSYw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxnz6R3MK5qsDjEKMDBqMTDK7A1PliINbGsuDL3
	EKMEB7OSCG9GR0KwEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDU0BeSbyhsYm5qbGppYmF
	iZklacJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCyZYcLz9i92+eozXI74fzz1Vpz+7b9
	Uzrzzaxxx4Y9y24Fqi0qf5K6+bPj9+/y8Q5O5dLXVKZybc/ZZMmd/zkjmC92rq+Ru2vdnYSK
	d85TLs8TuBlaf+TKQscj2lu//xM+dbLz4dKLjIt2r3lq/uyCyzoRz/xJ57X8Pr2cd71hd6pN
	8AYrk+l5SizFGYmGWsxFxYkA6IWwfPcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a soft reset software if a timeout happens.
This is applicable only for ADC_V2.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v2:
None
Changes since v1:
None
v0:
This change is a part of the patch reviewed at https://lkml.org/lkml/2013/11/5/92

 drivers/iio/adc/exynos_adc.c |   50 ++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 939aaf7..eddc58e 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -112,6 +112,30 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
 	return (unsigned int)match->data;
 }
 
+static void exynos_adc_hw_init(struct exynos_adc *info)
+{
+	u32 con1, con2;
+
+	if (info->version == ADC_V2) {
+		con1 = ADC_V2_CON1_SOFT_RESET;
+		writel(con1, ADC_V2_CON1(info->regs));
+
+		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
+			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
+		writel(con2, ADC_V2_CON2(info->regs));
+
+		/* Enable interrupts */
+		writel(1, ADC_V2_INT_EN(info->regs));
+	} else {
+		/* set default prescaler values and Enable prescaler */
+		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+
+		/* Enable 12-bit ADC resolution */
+		con1 |= ADC_V1_CON_RES;
+		writel(con1, ADC_V1_CON(info->regs));
+	}
+}
+
 static int exynos_read_raw(struct iio_dev *indio_dev,
 				struct iio_chan_spec const *chan,
 				int *val,
@@ -149,6 +173,8 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
 	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
+		exynos_adc_hw_init(info);
 		ret = -ETIMEDOUT;
 	} else {
 		*val = info->value;
@@ -230,30 +256,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
 	return 0;
 }
 
-static void exynos_adc_hw_init(struct exynos_adc *info)
-{
-	u32 con1, con2;
-
-	if (info->version == ADC_V2) {
-		con1 = ADC_V2_CON1_SOFT_RESET;
-		writel(con1, ADC_V2_CON1(info->regs));
-
-		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
-			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
-		writel(con2, ADC_V2_CON2(info->regs));
-
-		/* Enable interrupts */
-		writel(1, ADC_V2_INT_EN(info->regs));
-	} else {
-		/* set default prescaler values and Enable prescaler */
-		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
-
-		/* Enable 12-bit ADC resolution */
-		con1 |= ADC_V1_CON_RES;
-		writel(con1, ADC_V1_CON(info->regs));
-	}
-}
-
 static int exynos_adc_probe(struct platform_device *pdev)
 {
 	struct exynos_adc *info = NULL;
-- 
1.7.9.5

