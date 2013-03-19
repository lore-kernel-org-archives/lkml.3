Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3CSLv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:51:58 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:47921
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3CSLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:51:57 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: [Patch v2] rtc: fix for the DA9052 rtc device registration
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <dchen@diasemi.com>, <p_gortmaker@yahoo.com>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <ankur.raina@kpitcummins.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Mar 2013 17:19:18 +0530
Message-ID: <1363693758.6897.12.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the virtual irq since now MFD only handles virtual irq
Without this patch rtc device will fail in registration

Signed-off-by: Ashish <ashish.jangam@kpitcummins.com>
---
Changes since version v2:
- ported the patch for 3.9-rc3 kernel version
---
 drivers/rtc/rtc-da9052.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 0dde688..969abba 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -239,11 +239,9 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->irq = platform_get_irq_byname(pdev, "ALM");
-	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
-				da9052_rtc_irq,
-				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				"ALM", rtc);
+	rtc->irq =  DA9052_IRQ_ALARM;
+	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
+				da9052_rtc_irq, rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
 		return ret;
-- 
1.7.1


