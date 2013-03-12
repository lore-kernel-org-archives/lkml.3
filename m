Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3CLFvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:51:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30518 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CLFu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:50:58 -0400
X-AuditID: cbfee68d-b7f786d000005188-7d-513ec2419f14
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 06/14] backlight: adp8870: convert adp8870 to dev_pm_ops
Date: Tue, 12 Mar 2013 14:50:57 +0900
Message-id: <004301ce1ee5$911eec30$b35cc490$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAD0Vg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ13HQ3aBBg2LJCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozew9eY
	ClbzVUycdY2tgfE1dxcjJ4eEgInEy8/3GCFsMYkL99azdTFycQgJLGOU+LH2AXMXIwdY0btV
	1hDx6YwS06e3M0I4vxgljm69AtbNJqAm8eXLYXaQBhEBfYm2Fg2QMLNAqcTWB+9ZQGwhAVuJ
	u+ufM4KUcArYSWz5mwUSFhbwkGj9/IAdxGYRUJU4++AGmM0LVL63bTMzhC0o8WPyPRaIkVoS
	63ceZ4Kw5SU2r3kLdaa6xKO/uiBhEQEjiYNtv1khSkQk9r14B3axhMA5dontuxcwQ+wSkPg2
	+RALRK+sxKYDzJBgkJQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQrzgx
	t7g0L10vOT93EyMkInt3MN4+YH2IMRlo/URmKdHkfGBE55XEGxqbGVmYmpgaG5lbmpEmrCTO
	q9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsWjp/qOSkvwbdq82O2B4/9SRZja23LWz
	njq8L5D47l3c2VI781v+Xa2Xbqkvj3M6f5jWznx46fKsKVvlVjwJCq7NuJxxWS4xr+x4e8lq
	pqoLJtc1pDJ8M07eq9+6eBfzH88VaVbxU/dMKd+S9aZVJevIEfbTzfMq2r5HXHjBav3rmcSc
	Da1XXyuxFGckGmoxFxUnAgCZRbAj3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV3HQ3aBBm/7RSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM3sPXmApW81VMnHWNrYHxNXcXIweHhICJxLtV1l2MnECmmMSF
	e+vZuhi5OIQEpjNKTJ/ezgjh/GKUOLr1CiNIFZuAmsSXL4fZQZpFBPQl2lo0QMLMAqUSWx+8
	ZwGxhQRsJe6uf84IUsIpYCex5W8WSFhYwEOi9fMDdhCbRUBV4uyDG2A2L1D53rbNzBC2oMSP
	yfdYIEZqSazfeZwJwpaX2LzmLTPEyeoSj/7qgoRFBIwkDrb9ZoUoEZHY9+Id4wRGoVlIJs1C
	MmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc78+kdjCubLA4xCjAwajE
	w6v4zTZQiDWxrLgy9xCjBAezkghvxma7QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6ai
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgNKuytj31eNXk
	71oGlVNnVoorn4lW8eeoXyircpPdwOXwi3CJbVlXDoikuGlvVcoylIxdc/sEQ3b8bYeKf72i
	xz7tE9VPLp/2vO/ydBP5zwLv+nnXf/mnyHAk89nfu+pXZ9XuvDz73MuVmvwP0649at6z7n2c
	z/dHHW+YbJu/aYqZ22U+Vnv6S4mlOCPRUIu5qDgRAEqMP8A7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 712c25a..b71c4a2 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -947,25 +947,29 @@ static int adp8870_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int adp8870_i2c_suspend(struct i2c_client *client, pm_message_t message)
+#ifdef CONFIG_PM_SLEEP
+static int adp8870_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8870_clr_bits(client, ADP8870_MDCR, NSTBY);
 
 	return 0;
 }
 
-static int adp8870_i2c_resume(struct i2c_client *client)
+static int adp8870_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
-#else
-#define adp8870_i2c_suspend NULL
-#define adp8870_i2c_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp8870_i2c_pm_ops, adp8870_i2c_suspend,
+			adp8870_i2c_resume);
+
 static const struct i2c_device_id adp8870_id[] = {
 	{ "adp8870", 0 },
 	{ }
@@ -974,12 +978,11 @@ MODULE_DEVICE_TABLE(i2c, adp8870_id);
 
 static struct i2c_driver adp8870_driver = {
 	.driver = {
-		.name = KBUILD_MODNAME,
+		.name	= KBUILD_MODNAME,
+		.pm	= &adp8870_i2c_pm_ops,
 	},
 	.probe    = adp8870_probe,
 	.remove   = adp8870_remove,
-	.suspend = adp8870_i2c_suspend,
-	.resume  = adp8870_i2c_resume,
 	.id_table = adp8870_id,
 };
 
-- 
1.7.2.5


