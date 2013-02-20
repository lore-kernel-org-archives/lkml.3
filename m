Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab3BTGKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:10:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16842 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab3BTGKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:10:17 -0500
X-AuditID: cbfee68f-b7f656d000000d78-56-512468c621a5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 02/11] mfd: lm3533: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 15:10:14 +0900
Message-id: <002701ce0f30$f29f0e00$d7dd2a00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAAWRw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ91jGSqBBr3fVSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG745m9oLzXBXrHrI0ML7l6GLk5JAQMJHYcOsBM4QtJnHh3nq2
	LkYuDiGBZYwSCw7MYO1i5AAr+jXBFSI+nVFizZHNLBDObCaJB68usoN0swmoSXz5chjMFhHQ
	kug+dp4NpJlZwEXi6DQRkLCQgK3E97X/WEFsTgE7iV2PzoPZwgL2Eptvf2ICsVkEVCVWnjzB
	CGLzAtWv7jnCBmELSvyYfI8FxGYGGr9+53EmCFteYvOat8wQd6pLPPqrC3GBkcTzV42sECUi
	EvtevGMEOVlCYBG7xLONT1ghdglIfJt8iAWiV1Zi0wFoOEhKHFxxg2UCo8QsJJtnIdk8C8nm
	WUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRElX9OxjvHrA+xJgMtH4is5Rocj4w
	KvNK4g2NjU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFw
	xaON+fb/Hc+Gv7rzTstwwc5Yh+bkeG0PxXUslq9FD7isd9Q/HfH0xdJY3S2TX+xbve57zPW7
	uzZ8tbS9oFE56fu2t0d+l9WbPLh85gjz7fLXbufUas2svIOuv+KdfvlMzMbUR3w5D0KYdhnM
	nb+gdbP47vo4Q6UOlXidXJY+Dv6OtWHX/CyUWIozEg21mIuKEwGzudD8wAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoO6xDJVAg7e7FSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxu+OZvaC81wV6x6yNDC+
	5ehi5OCQEDCR+DXBtYuRE8gUk7hwbz1bFyMXh5DAdEaJNUc2s0A4s5kkHry6yA5SxSagJvHl
	y2EwW0RAS6L72Hk2kEHMAi4SR6eJgISFBGwlvq/9xwpicwrYSex6dB7MFhawl9h8+xMTiM0i
	oCqx8uQJRhCbF6h+dc8RNghbUOLH5HssIDYz0Pj1O48zQdjyEpvXvGWGuFld4tFfXYgLjCSe
	v2pkhSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERyzz6R2MK5ssDjEKMDBqMTDqzFfOVCINbGsuDL3EKMEB7OSCG+zk0qgEG9KYmVValF+
	fFFpTmrxIcZkoEcnMkuJJucD00leSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5akZqem
	FqQWwWxh4uCUamAMv6q44VT7E442/sj6pc8M/L2fxFUklgiG3W9mY62+a6TsJhfKuT1FQjrj
	WNP3tX9WPXt+913H+7UrQqKYwicYvxacIF1+Z13TnxNu6yMfGu6XXyO9WnudaMPljrecrvXf
	/GUstL4xz0ytvqFUtdXWeqJ9/grFvIXGvbdkNf3rVp262My4O1uJpTgj0VCLuag4EQBzMz4G
	HQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
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


