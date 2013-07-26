Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3GZCYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:24:39 -0400
Received: from [216.32.180.11] ([216.32.180.11]:47043 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab3GZCYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:24:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzd2iz1de098h1de097h8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Robin Gong <b38343@freescale.com>
To: <broonie@kernel.org>, <shawn.guo@linaro.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <lgirdwood@gmail.com>,
        <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator:pfuze100:  fix build warning and correct the binding doc
Date: Fri, 26 Jul 2013 10:27:18 +0800
Message-ID: <1374805638-12299-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix building warning and correct the binding doc

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 .../devicetree/bindings/regulator/pfuze100.txt     |    2 ++
 drivers/regulator/pfuze100-regulator.c             |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/pfuze100.txt b/Documentation/devicetree/bindings/regulator/pfuze100.txt
index 22e1a48..fc989b2 100644
--- a/Documentation/devicetree/bindings/regulator/pfuze100.txt
+++ b/Documentation/devicetree/bindings/regulator/pfuze100.txt
@@ -3,6 +3,8 @@ PFUZE100 family of regulators
 Required properties:
 - compatible: "fsl,pfuze100"
 - reg: I2C slave address
+
+Required child node:
 - regulators: This is the list of child nodes that specify the regulator
   initialization data for defined regulators. Please refer to below doc
   Documentation/devicetree/bindings/regulator/regulator.txt.
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index fcc7cd0..e2f9dcf 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -295,7 +295,7 @@ static inline struct device_node *match_of_node(int index)
 #else
 static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 {
-	return NULL;
+	return 0;
 }
 
 static inline struct regulator_init_data *match_init_data(int index)
-- 
1.7.5.4


