Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3IXJTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:19:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22910 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3IXJTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:19:30 -0400
X-AuditID: cbfee68e-b7f756d000004512-4d-5241592187a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 20/22] backlight: pcf50633: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:19:28 +0900
Message-id: <005a01ceb907$2b859f10$8290dd30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAhX9Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfV3FSMcgg0X/2C3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyef81s
	Be+4Kt7+38PewDiDs4uRk0NCwETibXMbK4QtJnHh3nq2LkYuDiGBZYwSrfPXscEU7TuykBUi
	sYhRom3aXaiqX4wSN46cYQepYhNQk/jy5TCQzcEhIqAv0daiARJmFsiRuP9kFliJkICtxLoP
	s8FsTgE7iVNLz4AtEBYIkJg6fx4ziM0ioCox+fhPRhCbF6j++cvjULagxI/J91ggZmpJbN7W
	xAphy0tsXvOWGWSthIC6xKO/uiBhEQEjiQs3J0KViEjse/GOEeRkCYFT7BL7WreyQOwSkPg2
	+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yY
	W1yal66XnJ+7iRESlX07GG8esD7EmAy0fiKzlGhyPjCq80riDY3NjCxMTUyNjcwtzUgTVhLn
	VWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6Ph3c0HAwjUacm8LjlzZ0Ll26ewpk2a4
	qwq+tZz2RPbTxX/vepSX1ml+/71UKOj38t3X32o92DB78hOTaNOZBgmcmm6/LMJ/Mf93Zr34
	hd1ZquhvMEdCe+TrDK3GptwjNe0l31OCDp9KPRgRv0t01e3De6dyarxc+qtX83yydVz/e/bb
	tg/EMpRYijMSDbWYi4oTAeTDOAbgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV3FSMcgg+9LWSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMnn/NbAXvuCre/t/D3sA4g7OLkZNDQsBEYt+RhawQtpjEhXvr
	2boYuTiEBBYxSrRNuwvl/GKUuHHkDDtIFZuAmsSXL4eBbA4OEQF9ibYWDZAws0COxP0ns8BK
	hARsJdZ9mA1mcwrYSZxaeoYNxBYWCJCYOn8eM4jNIqAqMfn4T0YQmxeo/vnL41C2oMSPyfdY
	IGZqSWze1sQKYctLbF7zlhlkrYSAusSjv7ogYREBI4kLNydClYhI7HvxjnECo9AsJJNmIZk0
	C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvln0jsYVzVYHGIU4GBU4uG9
	kOAQJMSaWFZcmXuIUYKDWUmE94atY5AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wPTUV5J
	vKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MHL93mkZ+jhlR1L4
	7i98nPPTlu+rv+H0ialYdXLZwuUKR4qiilsd7/ObHFilIVbi7XMldqfDlNZcAQWzg9rXnM8d
	VOPJCnl9aOWK0w7vdu9k8noUzbTygJZj3MmWh2/MnzNmqE7YFb57g+Ux8SJGjvksXVmSs37a
	RdxxF7u7WE9VR1Dd5djCMiWW4oxEQy3mouJEANj7/hs9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/pcf50633-backlight.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index b2184cf..b95d3b0 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -126,7 +126,8 @@ static int pcf50633_bl_probe(struct platform_device *pdev)
 
 	pcf_bl->pcf = dev_to_pcf50633(pdev->dev.parent);
 
-	pcf_bl->bl = backlight_device_register(pdev->name, &pdev->dev, pcf_bl,
+	pcf_bl->bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+						&pdev->dev, pcf_bl,
 						&pcf50633_bl_ops, &bl_props);
 
 	if (IS_ERR(pcf_bl->bl))
@@ -147,18 +148,8 @@ static int pcf50633_bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcf50633_bl_remove(struct platform_device *pdev)
-{
-	struct pcf50633_bl *pcf_bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(pcf_bl->bl);
-
-	return 0;
-}
-
 static struct platform_driver pcf50633_bl_driver = {
 	.probe =	pcf50633_bl_probe,
-	.remove =	pcf50633_bl_remove,
 	.driver = {
 		.name = "pcf50633-backlight",
 	},
-- 
1.7.10.4


