Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3J1GSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:18:54 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:1087 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab3J1GSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:18:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Peter Chen <peter.chen@freescale.com>
To: <linus.walleij@linaro.org>, <shawn.guo@linaro.org>,
        <s.hauer@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] pinctrl: imx: fix using pin->input_val wrongly
Date: Mon, 28 Oct 2013 14:01:16 +0800
Message-ID: <1382940076-11898-1-git-send-email-peter.chen@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit: "pinctrl: imx: Use struct type for pins" relaced
pin->input_reg by pin->input_val wrongly, fix it at this commit.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/pinctrl/pinctrl-imx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index d78dd81..4779b8e 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -245,11 +245,11 @@ static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 			 * The input_reg[i] here is actually some IOMUXC general
 			 * purpose register, not regular select input register.
 			 */
-			val = readl(ipctl->base + pin->input_val);
+			val = readl(ipctl->base + pin->input_reg);
 			val &= ~mask;
 			val |= select << shift;
-			writel(val, ipctl->base + pin->input_val);
-		} else if (pin->input_val) {
+			writel(val, ipctl->base + pin->input_reg);
+		} else if (pin->input_reg) {
 			/*
 			 * Regular select input register can never be at offset
 			 * 0, and we only print register value for regular case.
-- 
1.7.1


