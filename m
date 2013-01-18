Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3ARFaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:30:30 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:51845
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab3ARFa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:30:27 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898hbe9i1155h)
Subject: [Patch v1 5/5] onkey: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-input@vger.kernel.org>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 10:58:12 +0530
Message-ID: <1358486892.14373.17.camel@dhruva>
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
 drivers/input/misc/da9055_onkey.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index ee6ae3a..eec55b7 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -112,7 +112,7 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 
 	irq = regmap_irq_get_virq(da9055->irq_data, irq);
 	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
-				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				   "ONKEY", onkey);
 	if (err < 0) {
 		dev_err(&pdev->dev,
-- 
1.7.0.4


