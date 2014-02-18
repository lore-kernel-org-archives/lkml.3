Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaBRPuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:50:51 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:41611
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbaBRPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:50:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <broonie@kernel.org>
CC: <sachin.kamat@linaro.org>, <shawn.guo@linaro.org>, <festevam@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pfuze100-regulator: Revert "regulator: pfuze100: Use of_get_child_by_name"
Date: Tue, 18 Feb 2014 12:50:36 -0300
Message-ID: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
the following probe failure:

pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0                        
pfuze100-regulator 1-0008: FAB: 0, FIN: 0                                       
pfuze100-regulator 1-0008: regulators node not found                            
pfuze100-regulator: probe of 1-0008 failed with error -22 

Revert the offending commit so that we can probe the regulator successfully.

This reverts commit d7857c429475677a6a42d0dce7f870d6241edd41.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index c1cb202..b699d4e 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -254,7 +254,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	if (!np)
 		return 0;
 
-	parent = of_get_child_by_name(np, "regulators");
+	parent = of_find_node_by_name(np, "regulators");
 	if (!parent) {
 		dev_err(dev, "regulators node not found\n");
 		return -EINVAL;
-- 
1.8.1.2


