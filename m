Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3ARF0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:26:39 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:48900
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab3ARF0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:26:38 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898hbe9i1155h)
Subject: [patch v1 3/5] hwmon: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Samuel Ortiz <sameo@linux.intel.com>, <lm-sensors@lm-sensors.org>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 10:54:52 +0530
Message-ID: <1358486692.14373.12.camel@dhruva>
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
 drivers/hwmon/da9055-hwmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 9465c05..dfd0db1 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -284,7 +284,7 @@ static int da9055_hwmon_probe(struct platform_device *pdev)
 
 	ret = devm_request_threaded_irq(&pdev->dev, hwmon_irq,
 					NULL, da9055_auxadc_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					"adc-irq", hwmon);
 	if (ret != 0) {
 		dev_err(hwmon->da9055->dev, "DA9055 ADC IRQ failed ret=%d\n",
-- 
1.7.0.4


