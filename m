Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3G3K6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:58:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15758 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3G3K6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:58:53 -0400
X-AuditID: cbfee68e-b7f276d000002279-40-51f79c6b875e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 03/35] watchdog: use dev_get_platdata()
Date: Tue, 30 Jul 2013 19:58:51 +0900
Message-id: <008001ce8d13$c6805fc0$53811f40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6NE8DuJvLZSICrQ5eS2LQukQ0/6Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zQ93sOd8DDc7u0bSYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBkTZ59nKXiuXrGz9ShrA+MZxS5GTg4JAROJ+Y27GSFsMYkL99azdTFycQgJ
	LGOUuHzzIiNM0dUvz6ES0xklXr9/zwLh/GKUuLVwFjNIFZuAmsSXL4fZuxg5OEQE9CXaWjRA
	apgFNjBKnPz/lx2kRljASmLKlQ4WEJtFQFViQ+MDsA28ApYSZ9fNZIawBSV+TL4HVsMsoCWx
	fudxJghbXmLzmrfMEBcpSOw4+xqsV0RAT2LN+zmMEDUiEvtevGMEWSwhcI5d4tH0L8wQywQk
	vk0+xAJynISArMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLS
	K07MLS7NS9dLzs/dxAiJwr4djDcPWB9iTAZaP5FZSjQ5HxjFeSXxhsZmRhamJqbGRuaWZqQJ
	K4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgnJX1S9R7RXWcdbvPgYxU2Yp9u/WC
	3riHf0ub8WZC3jnd5afP7l3n9sBWWINRPaxItNyPodn4ndsxc7WoWdMzP24/qVoneHbWiqcb
	F++Y7vr88Ad+/g3dvIK7Z6xZtc2bmVUwhV+t0kj5ZHlR+auFhjlNLHpfV93//V5j1/K6rBU7
	l6ZuPnBtihJLcUaioRZzUXEiAKgwMJXYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd3sOd8DDdbsU7GYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzJs4+z1LwXL1iZ+tR1gbGM4pdjJwc
	EgImEle/PGeDsMUkLtxbD2RzcQgJTGeUeP3+PQuE84tR4tbCWcwgVWwCahJfvhxm72Lk4BAR
	0Jdoa9EAqWEW2MAocfL/X3aQGmEBK4kpVzpYQGwWAVWJDY0PGEFsXgFLibPrZjJD2IISPybf
	A6thFtCSWL/zOBOELS+xec1bZoiLFCR2nH0N1isioCex5v0cRogaEYl9L94xTmAUmIVk1Cwk
	o2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/kx6B+OqBotDjAIcjEo8
	vBsKvgUKsSaWFVfmHmKU4GBWEuE9P/F7oBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnA9NP
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwTprmlq95POrO
	DKGUUwobmU59k3d5/m3lfiXWnRJrBffunn7Mhf3O7G99s07ZBsn8cXCP/bHALfLnolq/89HG
	ykeOH22QrZ1aeSS94+MJ/7UP669NuNPt/MjN7/XPpT19Auc5L0ur6nDvsjecY5mX1eXJXiDA
	lM5mc5I/8Y7WZI8pwRI2Fk6PlFiKMxINtZiLihMBw/y4BzUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/iTCO_wdt.c         |    2 +-
 drivers/watchdog/mv64x60_wdt.c      |    2 +-
 drivers/watchdog/omap_wdt.c         |    2 +-
 drivers/watchdog/rdc321x_wdt.c      |    2 +-
 drivers/watchdog/stmp3xxx_rtc_wdt.c |    4 ++--
 drivers/watchdog/ux500_wdt.c        |    2 +-
 drivers/watchdog/wm831x_wdt.c       |    8 +++-----
 7 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 6130321..439b160 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -394,7 +394,7 @@ static int iTCO_wdt_probe(struct platform_device *dev)
 {
 	int ret = -ENODEV;
 	unsigned long val32;
-	struct lpc_ich_info *ich_info = dev->dev.platform_data;
+	struct lpc_ich_info *ich_info = dev_get_platdata(&dev->dev);
 
 	if (!ich_info)
 		goto out;
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index e4cf980..2f2ff19 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -255,7 +255,7 @@ static struct miscdevice mv64x60_wdt_miscdev = {
 
 static int mv64x60_wdt_probe(struct platform_device *dev)
 {
-	struct mv64x60_wdt_pdata *pdata = dev->dev.platform_data;
+	struct mv64x60_wdt_pdata *pdata = dev_get_platdata(&dev->dev);
 	struct resource *r;
 	int timeout = 10;
 
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index af88ffd..7b79ca0 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -205,7 +205,7 @@ static const struct watchdog_ops omap_wdt_ops = {
 
 static int omap_wdt_probe(struct platform_device *pdev)
 {
-	struct omap_wd_timer_platform_data *pdata = pdev->dev.platform_data;
+	struct omap_wd_timer_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct watchdog_device *omap_wdt;
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index b0f116c..8d5facd 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
index c97e98d..7bf8c50 100644
--- a/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -30,7 +30,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat period in seconds from 1 to "
 static int wdt_start(struct watchdog_device *wdd)
 {
 	struct device *dev = watchdog_get_drvdata(wdd);
-	struct stmp3xxx_wdt_pdata *pdata = dev->platform_data;
+	struct stmp3xxx_wdt_pdata *pdata = dev_get_platdata(dev);
 
 	pdata->wdt_set_timeout(dev->parent, wdd->timeout * WDOG_TICK_RATE);
 	return 0;
@@ -39,7 +39,7 @@ static int wdt_start(struct watchdog_device *wdd)
 static int wdt_stop(struct watchdog_device *wdd)
 {
 	struct device *dev = watchdog_get_drvdata(wdd);
-	struct stmp3xxx_wdt_pdata *pdata = dev->platform_data;
+	struct stmp3xxx_wdt_pdata *pdata = dev_get_platdata(dev);
 
 	pdata->wdt_set_timeout(dev->parent, 0);
 	return 0;
diff --git a/drivers/watchdog/ux500_wdt.c b/drivers/watchdog/ux500_wdt.c
index a614d84..d9af934 100644
--- a/drivers/watchdog/ux500_wdt.c
+++ b/drivers/watchdog/ux500_wdt.c
@@ -88,7 +88,7 @@ static struct watchdog_device ux500_wdt = {
 static int ux500_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
-	struct ux500_wdt_data *pdata = pdev->dev.platform_data;
+	struct ux500_wdt_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata) {
 		if (pdata->timeout > 0)
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index d4e47ed..e243bd0 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -184,7 +184,7 @@ static const struct watchdog_ops wm831x_wdt_ops = {
 static int wm831x_wdt_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *chip_pdata;
+	struct wm831x_pdata *chip_pdata = dev_get_platdata(pdev->dev.parent);
 	struct wm831x_watchdog_pdata *pdata;
 	struct wm831x_wdt_drvdata *driver_data;
 	struct watchdog_device *wm831x_wdt;
@@ -231,12 +231,10 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		wm831x_wdt->timeout = wm831x_wdt_cfgs[i].time;
 
 	/* Apply any configuration */
-	if (pdev->dev.parent->platform_data) {
-		chip_pdata = pdev->dev.parent->platform_data;
+	if (chip_pdata)
 		pdata = chip_pdata->watchdog;
-	} else {
+	else
 		pdata = NULL;
-	}
 
 	if (pdata) {
 		reg &= ~(WM831X_WDOG_SECACT_MASK | WM831X_WDOG_PRIMACT_MASK |
-- 
1.7.10.4


