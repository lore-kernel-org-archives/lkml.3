Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3D3FBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:01:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3D3FB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:01:28 -0400
X-AuditID: cbfee690-b7f136d000000fea-c8-517f502544a3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 4/7] watchdog: nuc900_wdt: use devm_*() functions
Date: Tue, 30 Apr 2013 14:01:25 +0900
Message-id: <001101ce455f$c441cf60$4cc56e20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX7ka6beYjyXqS4egvAzpd3XesA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zI13VgPpAg+6/VhZz1q9hs7i88BKr
	xeVdc9gsbqzbx27xZOEZJotbM16wOrB5XNss5nFixm8Wj53fG9g9+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK2PXHo+CFVIVd++3MTYw/hftYuTkkBAwkXh7+yIThC0mceHeerYuRi4OIYFl
	jBKHfj9lhyk6v38BO0RiOqPEvX8dUFW/GCW6T70Ha2cTUJP48uUwUBUHh4iAvkRbiwZIDbPA
	BkaJk///gk0SFnCRuHq8G8xmEVCVOLNlAiuIzStgKbGp7ykThC0o8WPyPRYQm1lAS2L9zuNM
	ELa8xOY1b5khLlKQ2HH2NSOILSKgJ7F79m1miBoRiX0v3jFC1Jxil2j6ZQ2xS0Di2+RDLCC3
	SQjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmEBI8sqRtHUguSC4qT0IhO94sTc4tK8
	dL3k/NxNjJAInLCD8d4B60OMyUDrJzJLiSbnAyM4ryTe0NjMyMLUxNTYyNzSjDRhJXFe9Rbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MDuytnJN3pp2ItJy7fOOikONaYkt+ihVMnihy
	46bvkZYN/r/c0lymP75WuvefyEx9gay8TqPGm/clj0ZcnPGzJfTSQqenc7Ya7m7bG3qiU+5F
	x9vJzs4r9q9W/rp7hdbK3tlRBzbdCE/2uHu6rfXxxY2eS84xzbDw1QmX+nzn2/9zZT/b176/
	/k2JpTgj0VCLuag4EQDU+86c1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQV3VgPpAg/vPzCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMXXs8ClZIVdy938bYwPhftIuRk0NC
	wETi/P4F7BC2mMSFe+vZuhi5OIQEpjNK3PvXAeX8YpToPvWeCaSKTUBN4suXw0AdHBwiAvoS
	bS0aIDXMAhsYJU7+/ws2SVjAReLq8W4wm0VAVeLMlgmsIDavgKXEpr6nTBC2oMSPyfdYQGxm
	AS2J9TuPM0HY8hKb17xlhrhIQWLH2deMILaIgJ7E7tm3mSFqRCT2vXjHOIFRYBaSUbOQjJqF
	ZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH+DPpHYyrGiwOMQpwMCrx8O5Y
	UhcoxJpYVlyZe4hRgoNZSYQ32rE+UIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgcknryTe
	0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYdQVzLodNVOL89yDo
	fEXCteMaTy7VyZpO7eh70tBRpbN153ffGjtD11pfc934J4+0Jv1+Knva/6Ylt1HZmysJ0dVr
	mnh0ZTIsJXQ6d+imugW3mG7zu5tg7VvAVWox1bVX8NmZh9OmCXAGFO31+eTtt94vdXa3x8vV
	rQmiDVNY13p3c3MIhSmxFGckGmoxFxUnAgCdnRKDNAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used sizeof(*nuc900_wdt) instead of sizeof(struct nuc900_wdt)
- declared 'nuc900_wdt->res' variable as logical variable

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


