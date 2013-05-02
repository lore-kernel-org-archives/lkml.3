Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3EBFwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:52:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47646 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3EBFwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:52:02 -0400
X-AuditID: cbfee68f-b7f066d000003683-ab-5181feec6ab8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 5/7] watchdog: rc32434_wdt: use devm_ioremap_nocache()
 functions
Date: Thu, 02 May 2013 14:51:39 +0900
Message-id: <000801ce46f9$1d910f50$58b32df0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+RzpMHsW/TuATsWpfcOP+oQ/ag==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA903/xoDDVZM1LKYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBkbV0xmK/jHU3H7xXrmBsZrXF2MnBwSAiYS1/edZYOwxSQu3FsPZgsJLGOU
	OLA4CaZm+fWJLF2MXEDx6YwSP3p72SCcX4wS2/ofM4JUsQmoSXz5cpi9i5GDQ0RAX6KtRQOk
	hllgA6PEyf9/2UFqhAUiJbb83s4KYrMIqErM3HOPGcTmFbCUWDB1O5QtKPFj8j0WEJtZQEti
	/c7jTBC2vMTmNW+ZIS5SkNhx9jXYXhEBPYmdPy+wQtSISOx78Y4RZLGEwDl2iZUPfzBCLBOQ
	+Db5EAvIcRICshKbDkDNkZQ4uOIGywRGsVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchY
	rzgxt7g0L10vOT93EyMkBvt3MN49YH2IMRlo/URmKdHkfGAM55XEGxqbGVmYmpgaG5lbmpEm
	rCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMaq8WCHmPpeT5foFxY/3zr/x3/mR
	sWr294fOC8tKz6Xd4Vh4WpzdSu3TbjVzqXx2yy2Xo+qv77dnNT+r/Pff7g/zbz//nXv5sIsb
	793bM/mT9unqMJnZHF5n5HdPsPtlwBbGyuXH/cyvVHZOmKapIrC47efv355sxVyeiZIbGDOv
	GOSn3Z8xUYmlOCPRUIu5qDgRAB6vzTPXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd03/xoDDSZ8kbCYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzNq6YzFbwj6fi9ov1zA2M17i6GDk5
	JARMJJZfn8gCYYtJXLi3nq2LkYtDSGA6o8SP3l4o5xejxLb+x4wgVWwCahJfvhxm72Lk4BAR
	0Jdoa9EAqWEW2MAocfL/X3aQGmGBSIktv7ezgtgsAqoSM/fcYwaxeQUsJRZM3Q5lC0r8mHwP
	bDOzgJbE+p3HmSBseYnNa94yQ1ykILHj7GuwvSICehI7f15ghagRkdj34h3jBEaBWUhGzUIy
	ahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzjz6R3MK5qsDjEKMDBqMTD
	+0G3MVCINbGsuDL3EKMEB7OSCO+C10Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgemn7yS
	eENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFzsFnWL9e+FdOfk
	GtbHLB9stO983qCbtOxai7Dh7EK/VedP2y3rfHrbVGDD9Lee2q52PT+D1rxS129v3csf9+Q5
	81v+Lt/FxwM23dzCnfzVUPDJhrenA3h2Ryg+8lurq7Zgi0321vP6GYcTjXvdXpmGHNhftcbh
	2EnrQCN7MatjR1hnVK0SFFNiKc5INNRiLipOBAD/bBhNNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_nocache() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
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


