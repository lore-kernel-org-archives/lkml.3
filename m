Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab3ARF2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:28:24 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:49689
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab3ARF2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:28:23 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898hbe9i1155h)
Subject: [patch v1 4/5] rtc: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: Samuel Ortiz <sameo@linux.intel.com>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 10:56:32 +0530
Message-ID: <1358486792.14373.14.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the irq state from high to the now default low
state.

This patch is dependent on the DA9055 MFD.

This patch is tested on smdk6410 board.

Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/rtc/rtc-da9055.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 8f0dcfe..918b16b 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -305,7 +305,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 	alm_irq = regmap_irq_get_virq(rtc->da9055->irq_data, alm_irq);
 	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
 					da9055_rtc_alm_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					"ALM", rtc);
 	if (ret != 0)
 		dev_err(rtc->da9055->dev, "irq registration failed: %d\n", ret);
-- 
1.7.0.4


