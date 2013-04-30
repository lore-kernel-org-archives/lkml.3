Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3D3FBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:01:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64670 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3D3FBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:01:42 -0400
X-AuditID: cbfee68f-b7f066d000003683-86-517f5035ce40
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 5/7] watchdog: rc32434_wdt: use devm_ioremap_nocache()
 functions
Date: Tue, 30 Apr 2013 14:01:41 +0900
Message-id: <001201ce455f$cdb6ec10$6924c430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX80A3b5AVhQESvS1ZRXSWUT0Nw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ13TgPpAg9d3DS3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV0bfiglsBcd5K97OX8jewDiZu4uRk0NCwERi77N3zBC2mMSFe+vZQGwhgWWM
	EtsW58HUXGyZzdjFyAUUn84osbd7JzOE84tR4tXSWewgVWwCahJfvhwGsjk4RAT0JdpaNEBq
	mAU2MEqc/P8XrEZYIFRi4osvYDaLgKrEzVuXmEBsXgFLiQ27n7JA2IISPybfA7OZBbQk1u88
	zgRhy0tsXvMW6lIFiR1nXzOC2CICehK/5zcwQtSISOx78Q7sUgmBc+wSLy+sYINYJiDxbfIh
	FpDjJARkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kbFecWJu
	cWleul5yfu4mRkgM9u9gvHvA+hBjMtD6icxSosn5wBjOK4k3NDYzsjA1MTU2Mrc0I01YSZxX
	rcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjrMnxxZeN5i3m/xI4J8Jv8VqDrVP9D8v4
	rb4a5OavzyxSpqh4boWTm/Av+2dlH5443LLl38R6LeLWY6uNH8vUdnfsY59dNf1sHl+ygIfC
	BKvd6jWMIkXRS5m6egPezO7LPNX4U+f7beb1nE/CbDgdAm+JXfof67p7XfOTWw9k5AQWP/N2
	fFGqxFKckWioxVxUnAgA5BFuYNcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV3TgPpAg1kL9CzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMvhUT2AqO81a8nb+QvYFxMncXIyeH
	hICJxMWW2YwQtpjEhXvr2boYuTiEBKYzSuzt3skM4fxilHi1dBY7SBWbgJrEly+HgWwODhEB
	fYm2Fg2QGmaBDYwSJ///BasRFgiVmPjiC5jNIqAqcfPWJSYQm1fAUmLD7qcsELagxI/J98Bs
	ZgEtifU7jzNB2PISm9e8ZYa4SEFix9nXYNeJCOhJ/J7fwAhRIyKx78U7xgmMArOQjJqFZNQs
	JKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4xp9J72Bc1WBxiFGAg1GJh3fH
	krpAIdbEsuLK3EOMEhzMSiK80Y71gUK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqcD0w/eSXx
	hsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmMOwxGypcpDKU2lr
	ZYttp3MWHG98GnfkcYvxA5V1msEXWD76Bs3/8fXq9EubYneK9F+8uGp63ayT8QaFikqWbT81
	tnAw/4803/55x3yj+fsvp0e9eP5n98llZ99XPPkw58CZuBXbHbK1qnef0A7I6V0yLeDo8o/l
	J6ZWhCq/UP8SeCA6g71adL8SS3FGoqEWc1FxIgDX734YNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_nocache() functions to make cleanup paths simpler.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/watchdog/rc32434_wdt.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f78bc00..9cf6bc7 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
 #include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For devm_ioremap_nocache */
 
 #include <asm/mach-rc32434/integ.h>	/* For the Watchdog registers */
 
@@ -271,7 +272,7 @@ static int rc32434_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	wdt_reg = ioremap_nocache(r->start, resource_size(r));
+	wdt_reg = devm_ioremap_nocache(&pdev->dev, r->start, resource_size(r));
 	if (!wdt_reg) {
 		pr_err("failed to remap I/O resources\n");
 		return -ENXIO;
@@ -293,23 +294,18 @@ static int rc32434_wdt_probe(struct platform_device *pdev)
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
 		pr_err("failed to register watchdog device\n");
-		goto unmap;
+		return ret;
 	}
 
 	pr_info("Watchdog Timer version " VERSION ", timer margin: %d sec\n",
 		timeout);
 
 	return 0;
-
-unmap:
-	iounmap(wdt_reg);
-	return ret;
 }
 
 static int rc32434_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&rc32434_wdt_miscdev);
-	iounmap(wdt_reg);
 	return 0;
 }
 
-- 
1.7.2.5


