Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab3ARFVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:21:25 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9431 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab3ARFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:21:23 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898hbe9i1155h)
Subject: [patch v1 1/5] mfd: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 10:49:37 +0530
Message-ID: <1358486377.14373.7.camel@dhruva>
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

This patch is tested on smdk6410 board.

Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/da9055-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index f56a1a9..49cb23d 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -391,7 +391,7 @@ int da9055_device_init(struct da9055 *da9055)
 		da9055->irq_base = pdata->irq_base;
 
 	ret = regmap_add_irq_chip(da9055->regmap, da9055->chip_irq,
-				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				  da9055->irq_base, &da9055_regmap_irq_chip,
 				  &da9055->irq_data);
 	if (ret < 0)
-- 
1.7.0.4


