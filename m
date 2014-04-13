Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaDMPJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 11:09:37 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:61881 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDMPJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 11:09:36 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pinctrl: pinctrl-imx: Print the mux_mode field in hex format
Date: Sun, 13 Apr 2014 12:09:05 -0300
Message-Id: <1397401745-4812-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

With debug enabled we get better readability dumps of the mux_mode register if 
we use hexadecimal format instead:

imx6sl-pinctrl 20e0000.iomuxc: MX6SL_PAD_FEC_REF_CLK: 0x10 0x0001b0a8

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/pinctrl/pinctrl-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index e118fb1..a24448e 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -491,7 +491,7 @@ static int imx_pinctrl_parse_groups(struct device_node *np,
 			pin->mux_mode |= IOMUXC_CONFIG_SION;
 		pin->config = config & ~IMX_PAD_SION;
 
-		dev_dbg(info->dev, "%s: %d 0x%08lx", info->pins[pin_id].name,
+		dev_dbg(info->dev, "%s: 0x%x 0x%08lx", info->pins[pin_id].name,
 				pin->mux_mode, pin->config);
 	}
 
-- 
1.8.3.2

