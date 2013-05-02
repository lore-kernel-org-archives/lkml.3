Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3EBFuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:50:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53941 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3EBFuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:50:37 -0400
X-AuditID: cbfee68d-b7f016d000007930-d3-5181feaae286
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/7] watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
Date: Thu, 02 May 2013 14:50:33 +0900
Message-id: <000501ce46f8$f65607b0$e3021710$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+PVLuklLJSAES7+2BJuFbhBFTw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA91V/xoDDTb2ClnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANYoLpuU
	1JzMstQifbsErowJbx6xF3zmrZjx6DlLA+NF7i5GTg4JAROJVzO+sUDYYhIX7q1n62Lk4hAS
	WMYocWPBEmaYovs3bkElFjFKbP94iQnC+cUoMbHjHlgVm4CaxJcvh9m7GDk4RAT0JdpaNEBq
	mAU2MEqc/P+XHaRGWMBXov/yDkYQm0VAVaJx+Q9WEJtXwFKir/c3lC0o8WPyPbCTmAW0JNbv
	PM4EYctLbF7zFuoiBYkdZ1+DzRER0JPo7njDDlEjIrHvxTtGkMUSAufYJZZ1rIRaJiDxbfIh
	FpDjJARkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kaFecWJu
	cWleul5yfu4mRkgU9u5gvH3A+hBjMtD6icxSosn5wCjOK4k3NDYzsjA1MTU2Mrc0I01YSZxX
	rcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjjX0djj8rjyi6bu66ZXmnzLprp831eU+M
	1A/ODXZ9zKg8e1Vx8oEuzbxi45uTL10NNNv+jTXkxhZNl6BGBuWasD15Pw74VK1gPn/glQDL
	gUfb9z7TCjFPvqdkd6j7xcZlqWKsX977iEjdmK7oyHv/ZERIVE9lh1rLjJDV5/8aKy8/FxVx
	UkhJiaU4I9FQi7moOBEA3ZTuCNgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd1V/xoDDZY381nMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZE948Yi/4zFsx49FzlgbGi9xdjJwc
	EgImEvdv3GKDsMUkLtxbD2RzcQgJLGKU2P7xEhOE84tRYmLHPWaQKjYBNYkvXw6zdzFycIgI
	6Eu0tWiA1DALbGCUOPn/LztIjbCAr0T/5R2MIDaLgKpE4/IfrCA2r4ClRF/vbyhbUOLH5Hss
	IDazgJbE+p3HmSBseYnNa94yQ1ykILHj7GuwOSICehLdHW/YIWpEJPa9eMc4gVFgFpJRs5CM
	moVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf4M6kdjCsbLA4xCnAwKvHw
	ftBtDBRiTSwrrsw9xCjBwawkwrvgNVCINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84HpJ68k
	3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGGMeP5+/+NntX0tu
	/HkVdV1O+UpL8sO8J5fjPRVVdhlN+N3pefSH7xOWOSeOvvTZXul28GGIWm0x8+vXwhPT9gRu
	8NgUl850w3fHNfs7a04xOuxafmPeMSbLioj6iQc3z+V1me7bYsb4Z+3Z0qaC4Id8Rxc5BxpE
	LspeEGekZdXi6662LCjD1kKJpTgj0VCLuag4EQCmTiKsNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_nocache() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/bcm63xx_wdt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index b2b80d4..a14a58d 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -249,7 +250,8 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, resource_size(r));
+	bcm63xx_wdt_device.regs = devm_ioremap_nocache(&pdev->dev, r->start,
+							resource_size(r));
 	if (!bcm63xx_wdt_device.regs) {
 		dev_err(&pdev->dev, "failed to remap I/O resources\n");
 		return -ENXIO;
@@ -258,7 +260,7 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 	ret = bcm63xx_timer_register(TIMER_WDT_ID, bcm63xx_wdt_isr, NULL);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register wdt timer isr\n");
-		goto unmap;
+		return ret;
 	}
 
 	if (bcm63xx_wdt_settimeout(wdt_time)) {
@@ -281,8 +283,6 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 
 unregister_timer:
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-unmap:
-	iounmap(bcm63xx_wdt_device.regs);
 	return ret;
 }
 
@@ -293,7 +293,6 @@ static int bcm63xx_wdt_remove(struct platform_device *pdev)
 
 	misc_deregister(&bcm63xx_wdt_miscdev);
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-	iounmap(bcm63xx_wdt_device.regs);
 	return 0;
 }
 
-- 
1.7.2.5


