Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3CUHLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:11:54 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16043
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757588Ab3CUHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:11:51 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: [patch v1]rtc: fix for DA9052/53 rtc device registration
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Mar 2013 12:39:07 +0530
Message-ID: <1363849747.31938.6.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds supports for the virtual irq since now MFD only handles virtual irq
Without this patch rtc device will fail in registration.

This patch is for Linux stable version 3.8.x 

Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/rtc/rtc-da9052.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 60b826e..e22c950 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -239,10 +239,10 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->irq = platform_get_irq_byname(pdev, "ALM");
-	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "ALM", rtc);
+	rtc->irq =  DA9052_IRQ_ALARM;
+
+	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
+				da9052_rtc_irq, rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
 		return ret;
-- 
1.7.1


