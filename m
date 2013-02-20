Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab3BTJ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:28:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20325 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934129Ab3BTJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:28:51 -0500
X-AuditID: cbfee68e-b7fc26d000001938-bc-5124975127d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 3/9] mfd: intel_msic: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 18:28:49 +0900
Message-id: <001101ce0f4c$b078f010$116ad030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAACJEA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI93A6SqBBq1H5S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGk3kTmAv281RsuV3ewDiJq4uRg0NCwETi3/XaLkZOIFNM4sK9
	9WxdjFwcQgLLGCVW/JjIBpEwkTjy5S8rRGI6o8SHA6vZIZzZTBJLnrYxglSxCahJfPlymB3E
	FhHQkug+dp4NZAOzgIvE0WkiIGEhAVuJR11bmUFsTgE7iZZr88BsYaCSFccXsYLYLAKqEus+
	TgCL8wLVv3z1jgnCFpT4MfkeC4jNDDR+/c7jTBC2vMTmNW+ZIZ5Rl3j0VxfiAiOJxd1HGSFK
	RCT2vXjHCHKyhMAidokz3feZIXYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQbJ6F
	ZPMsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJqr4djDcPWB9iTAZaP5FZSjQ5
	HxiVeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	GF6TvPeWwW9htzNR89/XvQ6a5xvl1ffyRf/+rAxu6ed1dr84nj8S0Ho3z3Ff0YGfE2wCrzpM
	yT2iV/X1oVbJ3wMf4/5fLXVhC7BimyA0Syt239PXiw7zVDn0PNHJdmP7uX/N1/gq9+lpD+9K
	RDFX2C42suNdr3XFf9rmb6v2tV+t4bpVH3NxihJLcUaioRZzUXEiALhgxZzAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoG7gdJVAg3n90haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48m8CcwF+3kqttwub2Cc
	xNXFyMkhIWAiceTLX1YIW0ziwr31bF2MXBxCAtMZJT4cWM0O4cxmkljytI0RpIpNQE3iy5fD
	7CC2iICWRPex80AdHBzMAi4SR6eJgISFBGwlHnVtZQaxOQXsJFquzQOzhYFKVhxfBLaMRUBV
	Yt3HCWBxXqD6l6/eMUHYghI/Jt9jAbGZgcav33mcCcKWl9i85i0zyCoJAXWJR391IS4wkljc
	fZQRokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcNQ+k97BuKrB4hCjAAejEg9vw0LlQCHWxLLiytxDjBIczEoivD87VAKFeFMSK6tSi/Lj
	i0pzUosPMSYDPTqRWUo0OR+YUPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1
	ILUIZgsTB6dUA+NKsZtKLKd7bvPl7r/QHcGVP+ebQJRd1JvP+18zHJiY4X391QlddqvJTzye
	mW8+Pi1B4mCYddjsX/+a0jNT8mY4+vsFbnnW17Es5OY9w13bC+OlGb989jskJ+EV9zN8W6P6
	jcPmVxS49u5WZuHeMjmp+G+gS3/TnLNfb6/O3hFW73uab9rZJe+UWIozEg21mIuKEwFz75eD
	HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/mfd/intel_msic.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 1804331..5be3b5e 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -323,7 +323,8 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 	if (pdata->ocd) {
 		unsigned gpio = pdata->ocd->gpio;
 
-		ret = gpio_request_one(gpio, GPIOF_IN, "ocd_gpio");
+		ret = devm_gpio_request_one(&pdev->dev, gpio,
+					GPIOF_IN, "ocd_gpio");
 		if (ret) {
 			dev_err(&pdev->dev, "failed to register OCD GPIO\n");
 			return ret;
@@ -332,7 +333,6 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 		ret = gpio_to_irq(gpio);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "no IRQ number for OCD GPIO\n");
-			gpio_free(gpio);
 			return ret;
 		}
 
@@ -359,8 +359,6 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 
 fail:
 	mfd_remove_devices(&pdev->dev);
-	if (pdata->ocd)
-		gpio_free(pdata->ocd->gpio);
 
 	return ret;
 }
@@ -368,12 +366,8 @@ fail:
 static void intel_msic_remove_devices(struct intel_msic *msic)
 {
 	struct platform_device *pdev = msic->pdev;
-	struct intel_msic_platform_data *pdata = pdev->dev.platform_data;
 
 	mfd_remove_devices(&pdev->dev);
-
-	if (pdata->ocd)
-		gpio_free(pdata->ocd->gpio);
 }
 
 static int intel_msic_probe(struct platform_device *pdev)
-- 
1.7.2.5


