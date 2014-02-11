Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaBKQRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:17:20 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:34353 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbaBKQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:17:19 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 11:17:19 EST
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-13.tower-193.messagelabs.com!1392135018!11843342!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402111610.s1BGAG67056463@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Tue, 11 Feb 2014 12:37:26 +0000
Subject: [PATCH V1] rtc: da9052: Remove redundant private structure field
To: Alessandro Zummo <a.zummo@towertech.it>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove redundant irq field in private rtc structure.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Acked-by: David Dajun Chen <david.chen@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140210

This issue was found when doing a code review whilst investigating
a different problem.

This patch has been test compiled on an amd64 server for both x86
and arm targets.

This patch has been spot verified using an SMDK6410 platform
fly-wired to a Dialog da9053 EVB.

 drivers/rtc/rtc-da9052.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 4385ca4..a1cbf64 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -26,7 +26,6 @@
 struct da9052_rtc {
 	struct rtc_device *rtc;
 	struct da9052 *da9052;
-	int irq;
 };
 
 static int da9052_rtc_enable_alarm(struct da9052 *da9052, bool enable)
@@ -240,8 +239,7 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->irq =  DA9052_IRQ_ALARM;
-	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
+	ret = da9052_request_irq(rtc->da9052, DA9052_IRQ_ALARM, "ALM",
 				da9052_rtc_irq, rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
-- 
end-of-patch for rtc: da9052: Remove redundant private structure field V1

