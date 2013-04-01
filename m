Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab3DAJtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:49:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47886 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3DAJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:49:00 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-c1-5159580b21c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 21/27] rtc: rtc-rp5c01: use devm_*() functions
Date: Mon, 01 Apr 2013 18:48:58 +0900
Message-id: <002001ce2ebe$21f102b0$65d30810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAO58A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ13uiMhAg5s/+CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeHJhBXPBT/6KdQ+fsDUwTuDtYuTkkBAwkVjxqZsVwhaTuHBvPVsXIxeHkMAyRonO
	+V2sMEVrOtexgNhCAtMZJZ7uDIQo+sUosXVqFyNIgk1ATeLLl8PsXYwcHCIC+hJtLRogNcwC
	vYwSZ3p3s0M020r8OPudGcTmFLCTeLNwHlivMJA9//FZsGUsAqoSv9c/YwOZwwtU/2ZpKkiY
	V0BQ4sfke2A3MAtoSazfeZwJwpaX2LzmLTNIuYSAusSjv7ogYREBI4lVGx5ClYtI7HvxjhHk
	HAmBe+wSV6YsYYdYJSDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJE77dzDePWB9iDEZaP1EZinR5HxgnOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXHJJlGZ7zk/
	uB1Mn9otEb20urDyA39AwYHbrldtvKqetaat3sbawu7XeOzqR90rOiI370+/IlQqZf1pgwv/
	G75A16PNfz/eYDb7L7XNvXGx2JaUTXof7C1c2ZbaZN9QTurQXnH6YVYfz+GvfuIyvGffFOv4
	KSjac375HCl5cfO10uZlYhM7vymxFGckGmoxFxUnAgCZHqmB6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3uiMhAg1f7uCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHhyYQVzwU/+inUPn7A1ME7g7WLk5JAQMJFY
	07mOBcIWk7hwbz0biC0kMJ1R4unOwC5GLiD7F6PE1qldjCAJNgE1iS9fDrN3MXJwiAjoS7S1
	aIDUMAv0Mkqc6d3NDtFsK/Hj7HdmEJtTwE7izcJ5YL3CQPb8x2dZQWwWAVWJ3+ufsYHM4QWq
	f7M0FSTMKyAo8WPyPbB7mAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAkcSqDQ+hykUk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ4Fn
	UjsYVzZYHGIU4GBU4uGNuBARKMSaWFZcmXuIUYKDWUmE1+cbUIg3JbGyKrUoP76oNCe1+BBj
	MtCfE5mlRJPzgQkqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoYj79eevYYd+EZZ2WOsJbwqJilMb1ZMcvvxjxefiZ9RbHTkWW5e96s87Fu6qj2XXBlRkzU
	xCf8b1OkJi/82vFQtyzy6MZYw1O8Uz14/3Dw7+CzO//bs29955vrr6J+KZ+bmtgt+DhHyKj5
	bdUaxuooheY1391PL7idyv+To1hvl9hF7v7oBaK6SizFGYmGWsxFxYkA7qiCgUYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rp5c01.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index d25d2f6..873c689 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -230,15 +230,13 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 	if (!res)
 		return -ENODEV;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&dev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->regs = ioremap(res->start, resource_size(res));
-	if (!priv->regs) {
-		error = -ENOMEM;
-		goto out_free_priv;
-	}
+	priv->regs = devm_ioremap(&dev->dev, res->start, resource_size(res));
+	if (!priv->regs)
+		return -ENOMEM;
 
 	sysfs_bin_attr_init(&priv->nvram_attr);
 	priv->nvram_attr.attr.name = "nvram";
@@ -251,27 +249,22 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, priv);
 
-	rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-rp5c01", &rp5c01_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		error = PTR_ERR(rtc);
-		goto out_unmap;
+		goto out;
 	}
 	priv->rtc = rtc;
 
 	error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
 	if (error)
-		goto out_unregister;
+		goto out;
 
 	return 0;
 
-out_unregister:
-	rtc_device_unregister(rtc);
-out_unmap:
+out:
 	platform_set_drvdata(dev, NULL);
-	iounmap(priv->regs);
-out_free_priv:
-	kfree(priv);
 	return error;
 }
 
@@ -280,9 +273,6 @@ static int __exit rp5c01_rtc_remove(struct platform_device *dev)
 	struct rp5c01_priv *priv = platform_get_drvdata(dev);
 
 	sysfs_remove_bin_file(&dev->dev.kobj, &priv->nvram_attr);
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->regs);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.2.5


