Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3CRJPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:15:15 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:14006
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab3CRJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:15:12 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: [patch v1] mfd: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Mar 2013 14:42:38 +0530
Message-ID: <1363597958.4228.7.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the irq state from high to the now default low.
Because the default PMIC irq state of DA9055 got changed from high to low.
This change should not affect any of the existing users since all of them
use active low state.

This patch has been tested on smdkv6410.

Signed-off-by: Ashish <ashish.jangam@kpitcummins.com>

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
1.7.1


