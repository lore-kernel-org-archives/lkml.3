Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3IXJRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:17:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:17:18 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-ab-5241589da830
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 16/22] backlight: lp855x: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:17:17 +0900
Message-id: <005601ceb906$dd1a6540$974f2fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAcjOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY925EY5BBjfPS1rMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBm/GwQL
	dglWTD4xg7mBcQlfFyMnh4SAicSbw7/ZIGwxiQv31oPZQgLLGCXWrleHqVl35SZQnAsovohR
	4v7rGewQzi9GiYtN7ewgVWwCahJfvhwGsjk4RAT0JdpaNEDCzAI5EvefzGKHGGorse7DbDCb
	U8BO4tTSM2DLhAX8JF7u2sUIYrMIqEosWPeXCcTmBao/03uaFcIWlPgx+R4LxEwtic3bmlgh
	bHmJzWveMoOslRBQl3j0VxckLCJgJPF7/3RGiBIRiX0v3jGCnCwhcI5d4uXXf8wQuwQkvk0+
	xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YW
	l+al6yXn525ihETkxB2M9w9YH2JMBlo/kVlKNDkfGNF5JfGGxmZGFqYmpsZG5pZmpAkrifOq
	t1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBMX/yH70TXq9Sjc+17TCZWOs1f+4Szf86Z
	FI/FAlErDixTjhTLV1+Yor5OXodd8In6Qo0Q//Ag0RX17GuuOmmsSap5ot4a+kPqS9XHYs4n
	zYX87DGGcQ+Dk62cH+1cwtCk/1pYJ9vIfu60U81P8hXEGsreLD9+8cbDtIMqB/Tn8GlHnD3i
	eVCJpTgj0VCLuag4EQD089l/3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd25EY5BBm17RC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM3w2CBbsEKyafmMHcwLiEr4uRk0NCwERi3ZWbbBC2mMSFe+uB
	bC4OIYFFjBL3X89gh3B+MUpcbGpnB6liE1CT+PLlMJDNwSEioC/R1qIBEmYWyJG4/2QWWImQ
	gK3Eug+zwWxOATuJU0vPgC0QFvCTeLlrFyOIzSKgKrFg3V8mEJsXqP5M72lWCFtQ4sfkeywQ
	M7UkNm9rYoWw5SU2r3nLDLJWQkBd4tFfXZCwiICRxO/90xkhSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/wzqR2MKxssDjEKcDAq8fDu
	8HYIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJKK8k
	3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGAuqqpYczHl7f+aT
	R/EesVut7/A9OdFS9dLq4b0z190EtJ5ZTny/UrHM/uz6q+fsPtjYHM2vTzJc9vOoj5J8/XH2
	5d9OKL67YbT48df07qKtVlKZEn+L77Dfk/np9v+Bw4y8orWlknGhP1br2alPurfohsATua+1
	lembr14tuOny93GMiteVZD8lluKMREMt5qLiRACcxtHOPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.
Also, unnecessary lp855x_backlight_unregister() is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp855x_bl.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 57f005a..cae80d5 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -300,7 +300,7 @@ static int lp855x_backlight_register(struct lp855x *lp)
 
 	props.brightness = pdata->initial_brightness;
 
-	bl = backlight_device_register(name, lp->dev, lp,
+	bl = devm_backlight_device_register(lp->dev, name, lp->dev, lp,
 				       &lp855x_bl_ops, &props);
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
@@ -310,12 +310,6 @@ static int lp855x_backlight_register(struct lp855x *lp)
 	return 0;
 }
 
-static void lp855x_backlight_unregister(struct lp855x *lp)
-{
-	if (lp->bl)
-		backlight_device_unregister(lp->bl);
-}
-
 static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -439,29 +433,24 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	ret = lp855x_configure(lp);
 	if (ret) {
 		dev_err(lp->dev, "device config err: %d", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	ret = lp855x_backlight_register(lp);
 	if (ret) {
 		dev_err(lp->dev,
 			"failed to register backlight. err: %d\n", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
 	if (ret) {
 		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
-		goto err_sysfs;
+		return ret;
 	}
 
 	backlight_update_status(lp->bl);
 	return 0;
-
-err_sysfs:
-	lp855x_backlight_unregister(lp);
-err_dev:
-	return ret;
 }
 
 static int lp855x_remove(struct i2c_client *cl)
@@ -471,7 +460,6 @@ static int lp855x_remove(struct i2c_client *cl)
 	lp->bl->props.brightness = 0;
 	backlight_update_status(lp->bl);
 	sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
-	lp855x_backlight_unregister(lp);
 
 	return 0;
 }
-- 
1.7.10.4


