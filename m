Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaDXMqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:46:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45064 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbaDXMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:57 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-c1-535904ef1f56
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:52 +0900
Message-id: <1398342897-23670-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSpPueJTLY4HynhcXB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNgctj06pONo+XE3+zefRt
	WcXoMXXKX0aP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAldHQOpup4CB3xdOLKxkbGI9zdjFy
	ckgImEj09axhh7DFJC7cW8/WxcjFISSwlFHi1P9VTF2MHGBF79exQ8SnM0qca/gB5TQxSezb
	9J8VpJtNQEti/4sbbCC2iICCxObeZ6wgRcwCzxglTlw9wQySEBYIk9iwYSkjyFQWAVWJrw9S
	QcK8Aq4S/yZ3sUBcISfxYc8jsIs4Bdwkzl64CjZTCKhmZcM/sJkSAvvYJb5e/88IkmAREJD4
	NvkQC8SlshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQIj
	4fS/Z707GG8fsD7EmAw0biKzlGhyPjCS8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBscL6blUzW8iMeRPzvbdd/fTuYubPtXP9dH/N9PnJd2VX
	ZfKsc1cWMj8Ut4uzss61nJc/T8fmyW+flfHMx4WvznTNdzzrZ6Yp8Z076dLr2eyBTTP2XUj4
	dM+Te3tRk77Cgbcq/T9SNN9cCtijqHDscNj0nEN/uh7e5w2Y77ZhlUjf7pXfXP/3iSuxFGck
	GmoxFxUnAgC3gxqgmgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd33LJHBBvcmGFgcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzGlpnMxUc5K54enElYwPjcc4uRg4OCQETiffr2LsYOYFMMYkL99azdTFycQgJTGeUONfw
	gx3CaWKS2LfpPytIFZuAlsT+FzfYQGwRAQWJzb3PWEGKmAWeMUqcuHqCGSQhLBAmsWHDUkaQ
	DSwCqhJfH6SChHkFXCX+Te5igdgmJ/FhzyOwzZwCbhJnL1wFmykEVLOy4R/rBEbeBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4+yZ9A7GVQ0WhxgFOBiVeHgVboUHC7EmlhVX5h5i
	lOBgVhLhnf0vIliINyWxsiq1KD++qDQntfgQYzLQUROZpUST84EpIK8k3tDYxMzI0sjc0MLI
	2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGD3CFb7s6Nr583Ph/iUrZQtnbxbRUVpZ
	/k93qclUze7Jrd/3H/WpPcdZn2pndXxRx6QDgk+fniyYenjNenNxiRC1bcvfaN/y4jggdv1a
	0cQbK/OmthVtbe1il+qatlTx+/sd9y5aJk96Ye/H5ZB/qvXPoQApoY8X255e2iNVfvHJW/9H
	xq/ZmFSUWIozEg21mIuKEwHpXNUS9wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index f0f18e2..2e15a24 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1175,8 +1175,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max77693_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -1184,14 +1184,13 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max77693_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
 	}
 
-
 	/* Initialize MUIC register by using platform data or default data */
 	if (pdata && pdata->muic_data) {
 		init_data = pdata->muic_data->init_data;
-- 
1.8.0

