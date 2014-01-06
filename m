Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaAFM33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:29:29 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:53964
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbaAFM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:29:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <anson.huang@freescale.com>,
        <linux-kernel@vger.kernel.org>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RFC] regulator: anatop-regulator: Remove unneeded memset()
Date: Mon, 6 Jan 2014 10:29:08 -0200
Message-ID: <1389011348-3145-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sreg is allocated via devm_kzalloc(), so there is no need to explicitly zero out
rdesc via memset().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Tested on a mx6qsabresd and I don't see the need for the memset.

Does anyone have any objection?

Thanks

 drivers/regulator/anatop-regulator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 3d4997a..862e63e 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -124,7 +124,6 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	sreg->initdata = initdata;
 	sreg->name = of_get_property(np, "regulator-name", NULL);
 	rdesc = &sreg->rdesc;
-	memset(rdesc, 0, sizeof(*rdesc));
 	rdesc->name = sreg->name;
 	rdesc->ops = &anatop_rops;
 	rdesc->type = REGULATOR_VOLTAGE;
-- 
1.8.1.2


