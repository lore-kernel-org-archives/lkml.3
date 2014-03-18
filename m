Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaCRJ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:58:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16069 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCRJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:58:51 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-4c-532818d92271
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: iop: fix devm_ioremap_resource() return value checking
Date: Tue, 18 Mar 2014 10:58:33 +0100
Message-id: <1625450.oZua1OVhNs@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2bEhrBBhuaTC3WvHCwmD71AqPF
	uVePWCx+LT3NZDHlz3Imi83z/zBaXN41h83iSfN1RgcOj52z7rJ7HP66kMVj8Z6XTB7/Xx5h
	87hzbQ+bx+dNch6r/rSwBrBHcdmkpOZklqUW6dslcGX0H3zBXvCbveL9llmMDYyv2LoYOTkk
	BEwkLq05wA5hi0lcuLceLC4ksIhR4uQ7li5GLiC7hUmi88QyRpAEm4CVxMT2VWC2iECIxJue
	XcwgRcwCDxglLnzaA9YtLOAr8fNGAwuIzSKgKrF69RIwm1dAU6Lv5EVmEFtUwFNix/aVbBBx
	QYkfk++B1TALyEvs2z+VFcLWkli/8zjTBEa+WUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4JB+Jr2DcVWDxSFGAQ5GJR7eF2zqwUKsiWXFlbmHGCU4mJVEeE+IaAQL
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYGR+3bJeCxiw
	YdFPJ08oXrP1SduLjY2Mcy2CGFaXzXgQr1iQsdZy0fo7y7PtD76+0X/qTl1K01Nr/ZeJ/pN6
	j6dMrbns6LWu+vH/9dn7pDe8ikj/Hnzp7M9Vy6b9af5ysZPzrJTd4hPu2nodnpXWbg26GY2u
	7xo7Z5/L1PvOZG++NpE11c6qQImlOCPRUIu5qDgRAMbJNoVlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() returns a pointer to the remapped memory or
an ERR_PTR() encoded error code on failure.  Fix the check inside
iop3xx_gpio_probe() accordingly.

Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/gpio/gpio-iop.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/gpio/gpio-iop.c
===================================================================
--- a/drivers/gpio/gpio-iop.c	2014-03-14 16:45:08.152724313 +0100
+++ b/drivers/gpio/gpio-iop.c	2014-03-18 10:50:01.903194680 +0100
@@ -111,6 +111,8 @@ static int iop3xx_gpio_probe(struct plat
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	return gpiochip_add(&iop3xx_chip);
 }

