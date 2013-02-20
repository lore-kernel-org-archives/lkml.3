Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab3BTJ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:28:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56706 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab3BTJ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:28:17 -0500
X-AuditID: cbfee691-b7f556d000001a24-c0-5124972f7993
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 2/9] mfd: lm3533: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 18:28:15 +0900
Message-id: <001001ce0f4c$9c41c450$d4c54cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAAlbg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY1396SqBBvt6VCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGsQXvmQqec1Us/tjF3sD4j6OLkYNDQsBE4tOs0C5GTiBTTOLC
	vfVsXYxcHEICyxglnr7dzAaRMJFo/PWRGSIxnVHi/639jBDObCaJjzMegFWxCahJfPlymB3E
	FhHQkug+dp4NZAOzgIvE0WkiIGEhAVuJR11bmUFsTgE7iZZr88BsYQEHiRWb+8BaWQRUJfZO
	+g42kheofsnNlywQtqDEj8n3wGxmoPHrdx5ngrDlJTavecsM8Yy6xKO/uhAXGEn0ztvICFEi
	IrHvxTuwkyUE5rFLPL1znhFil4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkLiauIPx/gHrQ4zJQOsnMkuJJucD
	4zKvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjl
	Zsp6NMw85VR5dE1oovRTX/mDb5L3RAT37V/N0qZUf3/38kdPP6z7JfFVsLZNblJmwq0znziK
	ts3hLvMQffDkQV3B9mvz1tyZuOyP1NTDnMyvN3jOPnGr8pNnX8WK+yfKe9hiQt5I58ZuvfVr
	JsfptS1vDvLuPbiDQ7k6L5m1YHUxQyL3lfsVSizFGYmGWsxFxYkAe3VtYsECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoK7+dJVAg/O7FCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxrEF75kKnnNVLP7Yxd7A
	+I+ji5GTQ0LARKLx10dmCFtM4sK99WxdjFwcQgLTGSX+39rPCOHMZpL4OOMBG0gVm4CaxJcv
	h9lBbBEBLYnuY+eB4hwczAIuEkeniYCEhQRsJR51bQUbyilgJ9FybR6YLSzgILFicx9YK4uA
	qsTeSd/BRvIC1S+5+ZIFwhaU+DH5HpjNDDR+/c7jTBC2vMTmNW+ZQVZJCKhLPPqrC3GBkUTv
	vI2MECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxguP2mfQOxlUNFocYBTgYlXh4GxYqBwqxJpYVV+YeYpTgYFYS4f3ZoRIoxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAlJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2amp
	BalFMFuYODilGhgbF3UY9nBvWis4eYLxn5v+KgeYEpyUT7mwW62uWaakEKuiE8oWfFmVQ3ex
	5a98JffjvzpMLOY4dTS/V5svqTNLfjfXyZnnvqzbrFF1IHyrr9ri5e9YNE87sU4wcS/L1ykO
	uvaB0TL96rZnM3s/l9Zs85XbeOzwr8K80oCSdIuMvDIO0Yp3SUosxRmJhlrMRcWJAFEVAcgf	AwAA
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

 drivers/mfd/lm3533-core.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index ceebf2c..4b7e6da 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -496,8 +496,8 @@ static int lm3533_device_init(struct lm3533 *lm3533)
 	dev_set_drvdata(lm3533->dev, lm3533);
 
 	if (gpio_is_valid(lm3533->gpio_hwen)) {
-		ret = gpio_request_one(lm3533->gpio_hwen, GPIOF_OUT_INIT_LOW,
-								"lm3533-hwen");
+		ret = devm_gpio_request_one(lm3533->dev, lm3533->gpio_hwen,
+					GPIOF_OUT_INIT_LOW, "lm3533-hwen");
 		if (ret < 0) {
 			dev_err(lm3533->dev,
 				"failed to request HWEN GPIO %d\n",
@@ -528,8 +528,6 @@ err_unregister:
 	mfd_remove_devices(lm3533->dev);
 err_disable:
 	lm3533_disable(lm3533);
-	if (gpio_is_valid(lm3533->gpio_hwen))
-		gpio_free(lm3533->gpio_hwen);
 
 	return ret;
 }
@@ -542,8 +540,6 @@ static void lm3533_device_exit(struct lm3533 *lm3533)
 
 	mfd_remove_devices(lm3533->dev);
 	lm3533_disable(lm3533);
-	if (gpio_is_valid(lm3533->gpio_hwen))
-		gpio_free(lm3533->gpio_hwen);
 }
 
 static bool lm3533_readable_register(struct device *dev, unsigned int reg)
-- 
1.7.2.5


