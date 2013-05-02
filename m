Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3EBFv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:51:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47594 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3EBFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:51:24 -0400
X-AuditID: cbfee691-b7fe56d000004b96-e0-5181fedb6a71
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 4/7] watchdog: nuc900_wdt: use devm_*() functions
Date: Thu, 02 May 2013 14:51:23 +0900
Message-id: <000701ce46f9$13ee2be0$3bca83a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+RL70cKUVaQWRyaLJtyZ/n6RIQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zQ93b/xoDDeYu0raYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBkH3q1mL5guWfHx0y62BsYW0S5GDg4JAROJZd+Vuhg5gUwxiQv31rN1MXJx
	CAksY5S4da+fESJhIjFn6RuoxHRGiWsfj7BDOL8YJY70nWQGqWITUJP48uUwO8hUEQF9ibYW
	DZAaZoENjBIn//8FiwsLeEjcWhwGYrIIqErM3M0C0skrYCmx5+kyZghbUOLH5HtgcWYBLYn1
	O48zQdjyEpvXvGWGuEdBYsfZ12C3iQjoSbQ8msgGUSMise/FO0aQtRICp9gl+pb0gzWzCAhI
	fJt8iAXiYVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqlec
	mFtcmpeul5yfu4kREn8TdzDeP2B9iDEZaP1EZinR5Hxg/OaVxBsamxlZmJqYGhuZW5qRJqwk
	zqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFmybnpdvrOtqlxl5rZhe97ua3eNuFz
	/+PnDcu+LLz1xXp5ZFH9pfLCwxErLvP+Kc9I3BsQEn6hj5PpF1uf+ZTjdX1lzzQWlFzhUKw+
	8cRCtKfliBG7ZP0xzSdO83i0Dygr7jY6L7fqd+c0TbvZOy5zJO4pZ9pqFOF8Kjoo78qMe2t8
	g9L+f1JiKc5INNRiLipOBADKhJi11QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd3b/xoDDW4sULeYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzDrxbzV4wXbLi46ddbA2MLaJdjJwc
	EgImEnOWvmGDsMUkLtxbD2RzcQgJTGeUuPbxCDuE84tR4kjfSWaQKjYBNYkvXw4DJTg4RAT0
	JdpaNEBqmAU2MEqc/P8XLC4s4CFxa3EYiMkioCoxczcLSCevgKXEnqfLmCFsQYkfk++BxZkF
	tCTW7zzOBGHLS2xe85YZ4h4FiR1nXzOC2CICehItjyayQdSISOx78Y5xAqPALCSjZiEZNQvJ
	qFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7vZ9I7GFc1WBxiFOBgVOLh/aDb
	GCjEmlhWXJl7iFGCg1lJhHfBa6AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTT15JvKGx
	iZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MPakf+95MnVJOK/eYpU/
	Mx1Wzlu03mD+Fc/1a7P2nn/tuflqml5Vcer9B5PPTeu8d3a33pL5Rm9O+vidlDKdyv3zwI0T
	NkU/Z7txle58mviu/SKThHL/Mq0izm1bYyP3N4lWMW/OSDivWxjx4VzCnaM1bZzJ9iXfEiSD
	Nhq1Htodcf3HLubUu0FKLMUZiYZazEXFiQCG1/9sMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/nuc900_wdt.c |   50 +++++++++--------------------------------
 1 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 04c45a1..e2b6d2c 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -61,7 +61,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 struct nuc900_wdt {
-	struct resource  *res;
 	struct clk	 *wdt_clock;
 	struct platform_device *pdev;
 	void __iomem	 *wdt_base;
@@ -244,9 +243,11 @@ static struct miscdevice nuc900wdt_miscdev = {
 
 static int nuc900wdt_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	int ret = 0;
 
-	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
+	nuc900_wdt = devm_kzalloc(&pdev->dev, sizeof(*nuc900_wdt),
+				GFP_KERNEL);
 	if (!nuc900_wdt)
 		return -ENOMEM;
 
@@ -254,33 +255,20 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 
 	spin_lock_init(&nuc900_wdt->wdt_lock);
 
-	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (nuc900_wdt->res == NULL) {
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource specified\n");
-		ret = -ENOENT;
-		goto err_get;
+		return -ENOENT;
 	}
 
-	if (!request_mem_region(nuc900_wdt->res->start,
-				resource_size(nuc900_wdt->res), pdev->name)) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_get;
-	}
-
-	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-	if (nuc900_wdt->wdt_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() region\n");
-		ret = -EINVAL;
-		goto err_req;
-	}
+	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(nuc900_wdt->wdt_base))
+		return PTR_ERR(nuc900_wdt->wdt_base);
 
-	nuc900_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	nuc900_wdt->wdt_clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(nuc900_wdt->wdt_clock)) {
 		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
-		ret = PTR_ERR(nuc900_wdt->wdt_clock);
-		goto err_map;
+		return PTR_ERR(nuc900_wdt->wdt_clock);
 	}
 
 	clk_enable(nuc900_wdt->wdt_clock);
@@ -298,14 +286,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 
 err_clk:
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-err_map:
-	iounmap(nuc900_wdt->wdt_base);
-err_req:
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-err_get:
-	kfree(nuc900_wdt);
 	return ret;
 }
 
@@ -314,14 +294,6 @@ static int nuc900wdt_remove(struct platform_device *pdev)
 	misc_deregister(&nuc900wdt_miscdev);
 
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-
-	iounmap(nuc900_wdt->wdt_base);
-
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-
-	kfree(nuc900_wdt);
 
 	return 0;
 }
-- 
1.7.2.5


