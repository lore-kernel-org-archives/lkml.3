Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab3LXHXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 02:23:37 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:53771
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab3LXHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 02:23:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Anson Huang <b20788@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: imx: improve status check of clock gate
Date: Tue, 24 Dec 2013 14:21:27 -0500
Message-ID: <1387912887-6402-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ccm clock gate, both 2b'11 and 2b'01 should be treated
as clock enabled, see below description in CCM, whenver CPU
trys to check clock gate's status, system will be in run mode.

2b'00: clock is off during all modes;
2b'01: clock is on in run mode, but off in wait and stop mode;
2b'10: Not applicable;
2b'11: clock is on during all modes, except stop mode.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 arch/arm/mach-imx/clk-gate2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
index a63e415..a2ecc00 100644
--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -72,7 +72,7 @@ static int clk_gate2_is_enabled(struct clk_hw *hw)
 
 	reg = readl(gate->reg);
 
-	if (((reg >> gate->bit_idx) & 3) == 3)
+	if (((reg >> gate->bit_idx) & 1) == 1)
 		return 1;
 
 	return 0;
-- 
1.7.9.5


