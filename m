Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaBTQrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:47:23 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:57779
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbaBTQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:47:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pfuze100-regulator: Return error on of_node_get() failure
Date: Thu, 20 Feb 2014 13:47:02 -0300
Message-ID: <1392914822-25825-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If of_node_get() fails, we should return an error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index dcb03ce..1296221 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -252,7 +252,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 
 	np = of_node_get(dev->of_node);
 	if (!np)
-		return 0;
+		return -EINVAL;
 
 	parent = of_get_child_by_name(np, "regulators");
 	if (!parent) {
-- 
1.8.1.2


