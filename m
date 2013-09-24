Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3IXJbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:31:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63536 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3IXJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:31:17 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-48-52415bd80998
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
In-reply-to: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
Subject: [PATCH 4/5] backlight: cr_bllcd: use
 devm_{backlight,lcd}_device_register()
Date: Tue, 24 Sep 2013 18:31:04 +0900
Message-id: <007801ceb908$ca2348b0$5e69da10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65CHjKuB0v+SsdTFGS6PUVVZI9RwAADmpQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90b0Y5BBldXyVjMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmPdnQy
	F0zmr9i/UrOB8QNPFyMnh4SAiUTn1AtsELaYxIV764FsLg4hgWWMEscud7DDFHW8WscKkZjO
	KDHl2ztGkISQwC9Giee3Q0FsNgE1iS9fDgM1cHCICOhLtLVogISZBXIk7j+ZxQ5Rbivx8vJj
	ZhCbU8BOYtm+i2C2sECYxO4Z21lAbBYBVYm10/+CjeEFqj/bFAES5hUQlPgx+R4LxEgtic3b
	mlghbHmJzWveMoOUSwioSzz6qwsSFhEwkri3aStUiYjEvhcgB3MBlZxjl/i0fyo7xCoBiW+T
	D7FA9MpKbDrADPGtpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5
	xaV56XrJ+bmbGCHxOGEH470D1ocYk4HWT2SWEk3OB8ZzXkm8obGZkYWpiamxkbmlGWnCSuK8
	6i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYKzbr9zn2u8lIfnu6ZtqeGXy3ZZ/1psrx
	5zctuy1ZFDEnoyiif39L5uaJ29K8/2vGHv1aIMh4r75supb4uQ2yPjEVSwOOFQX/Z1VKDH7z
	08k2wjPSyE363tKgvf9y9L/onJi/OaJkU7PMyWjLWfdfCHAJVLtfdFOVtH9Uw7BksfDch1Nf
	dlUqsRRnJBpqMRcVJwIAOJ+H1t0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd0b0Y5BBmd2SVjMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZj3Z0MhdM5q/Yv1KzgfEDTxcjJ4eEgIlEx6t1rBC2mMSFe+vZ
	uhi5OIQEpjNKTPn2jhEkISTwi1Hi+e1QEJtNQE3iy5fD7F2MHBwiAvoSbS0aIGFmgRyJ+09m
	sUOU20q8vPyYGcTmFLCTWLbvIpgtLBAmsXvGdhYQm0VAVWLt9L9gY3iB6s82RYCEeQUEJX5M
	vscCMVJLYvO2JlYIW15i85q3zCDlEgLqEo/+6oKERQSMJO5t2gpVIiKx78U7xgmMQrOQTJqF
	ZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM42p9J7WBc2WBxiFGAg1GJ
	h3eHt0OQEGtiWXFl7iFGCQ5mJRHeG7aOQUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0xE
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuCIuIEDt0hOp
	H795XyTuCI9e2izNZKURUCRy8uh0lqr7jkGVWu+0PvI+mBBizTLz4ZPEdU+2Lf4545dQZu4N
	O4P63in/tj1bH8zyp2jd3PjTKvrsfDoxhoYs6z0nX29d8/hUWibv2QNKq82nXH+7odtg9576
	7MuHd12y2fuU07s7sKw8uE35tRJLcUaioRZzUXEiAKb6hrk6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() and devm_lcd_device_register()
to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/cr_bllcd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index 37bae80..f3fed9e 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -195,16 +195,17 @@ static int cr_backlight_probe(struct platform_device *pdev)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
-	bdp = backlight_device_register("cr-backlight", &pdev->dev, NULL,
-					&cr_backlight_ops, &props);
+	bdp = devm_backlight_device_register(&pdev->dev, "cr-backlight",
+					&pdev->dev, NULL, &cr_backlight_ops,
+					&props);
 	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
 		return PTR_ERR(bdp);
 	}
 
-	ldp = lcd_device_register("cr-lcd", &pdev->dev, NULL, &cr_lcd_ops);
+	ldp = devm_lcd_device_register(&pdev->dev, "cr-lcd", &pdev->dev, NULL,
+					&cr_lcd_ops);
 	if (IS_ERR(ldp)) {
-		backlight_device_unregister(bdp);
 		pci_dev_put(lpc_dev);
 		return PTR_ERR(ldp);
 	}
@@ -215,8 +216,6 @@ static int cr_backlight_probe(struct platform_device *pdev)
 
 	crp = devm_kzalloc(&pdev->dev, sizeof(*crp), GFP_KERNEL);
 	if (!crp) {
-		lcd_device_unregister(ldp);
-		backlight_device_unregister(bdp);
 		pci_dev_put(lpc_dev);
 		return -ENOMEM;
 	}
@@ -241,8 +240,6 @@ static int cr_backlight_remove(struct platform_device *pdev)
 	crp->cr_backlight_device->props.max_brightness = 0;
 	cr_backlight_set_intensity(crp->cr_backlight_device);
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_POWERDOWN);
-	backlight_device_unregister(crp->cr_backlight_device);
-	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
 
 	return 0;
-- 
1.7.10.4


