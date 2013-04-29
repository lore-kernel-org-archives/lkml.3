Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3D2Jf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:35:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65227 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3D2Jfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:35:54 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-fd-517e3ef94685
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 5/7] watchdog: rc32434_wdt: use devm_ioremap_nocache()
 functions
Date: Mon, 29 Apr 2013 18:35:53 +0900
Message-id: <000f01ce44bc$f1342570$d39c7050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvPBJwNNHxheyQlWTKR09I+DyDA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zI92fdnWBBru2i1nMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	bFwxma3gH0/F7RfrmRsYr3F1MXJySAiYSHz5doMFwhaTuHBvPVsXIxeHkMAyRolFc9qZYYo2
	7t8DlVjEKNE77RAjhPOLUWLqjR2MIFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhglDjwdCkr
	SI2wQKTElt/bwWwWAVWJCzNWMoLU8wpYSnyYLgYS5hUQlPgx+R7YRcwCWhLrdx5ngrDlJTav
	eQt1kILEjrOvwdaKCOhJrOlZBFUvIrHvxTuw2yQEDrFLfO7bBLVLQOLb5EMsILskBGQlNh2A
	miMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SLz17WC8ecD6EGMy0PqJzFKiyfnAeM0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA2OXqoziUmGbC0JrFb/wcXTNa+Nc9vlKoNB0CwHb7auVln8+
	qaNnqB136mrYxoSLv/2XXEnmn7O5ZMdnb8Gvy6esfsE3f49N9U05ra2vpzEoisrGq4hU9Qla
	2knZXFppLn/mDHtzt3nWi2Tnmim50Z0H171R8hQ5KRnk5/44VcdC436c0wnZx0osxRmJhlrM
	RcWJAFYBlBbNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd2fdnWBBgtPCFnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZmxcMZmt4B9Pxe0X65kbGK9xdTFyckgImEhs3L+HDcIW
	k7hwbz2QzcUhJLCIUaJ32iFGCOcXo8TUGzsYQarYBNQkvnw5zN7FyMEhIqAv0daiAVLDLNDB
	KHHg6VJWkBphgUiJLb+3g9ksAqoSF2asZASp5xWwlPgwXQwkzCsgKPFj8j0WEJtZQEti/c7j
	TBC2vMTmNW+ZIQ5SkNhx9jXYWhEBPYk1PYug6kUk9r14xziBUWAWklGzkIyahWTULCQtCxhZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/Mz6R2MqxosDjEKcDAq8fAGbK4NFGJNLCuu
	zD3EKMHBrCTCu8KyLlCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84GJJq8k3tDYxMzI0sjM
	wsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGFVf7vC+sqA0O8/jIic703zZRyyv
	L7t78ReX6Gac325Rx/32X/ma0CfFS22Xsry7ocDz/vXy/SdOnWA9qrvkdbjAdrsCyWPr+jrk
	LZd0VFw+XZbYnXEoVOx02rGnjMZni19ZB8uvXlnC51vL+XrfsRVzH3ZV8vx4rpK/49rTfhkp
	pzdfg6/vZlZiKc5INNRiLipOBABpiEzjKgMAAA==
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


