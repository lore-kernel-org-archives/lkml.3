Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaGGQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:09:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54185 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaGGQJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:09:26 -0400
Date: Mon, 7 Jul 2014 21:39:16 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] sh-pfc: sh73a0: Introduce the use of devm_regulator_register
Message-ID: <20140707160916.GA9238@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using regulator_register to
devm_regulator_register and does away the calls to regulator_unregister.
The sh73a0_pinmux_soc_exit function is no longer needed and is removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
To send to: Linus Walleij <linus.walleij@linaro.org>,linux-kernel@vger.kernel.org
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index ee370de..0bd8f44 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -3842,7 +3842,8 @@ static int sh73a0_pinmux_soc_init(struct sh_pfc *pfc)
 	cfg.init_data = &sh73a0_vccq_mc0_init_data;
 	cfg.driver_data = pfc;
 
-	data->vccq_mc0 = regulator_register(&sh73a0_vccq_mc0_desc, &cfg);
+	data->vccq_mc0 = devm_regulator_register(pfc->dev,
+						 &sh73a0_vccq_mc0_desc, &cfg);
 	if (IS_ERR(data->vccq_mc0)) {
 		ret = PTR_ERR(data->vccq_mc0);
 		dev_err(pfc->dev, "Failed to register VCCQ MC0 regulator: %d\n",
@@ -3855,16 +3856,8 @@ static int sh73a0_pinmux_soc_init(struct sh_pfc *pfc)
 	return 0;
 }
 
-static void sh73a0_pinmux_soc_exit(struct sh_pfc *pfc)
-{
-	struct sh73a0_pinmux_data *data = pfc->soc_data;
-
-	regulator_unregister(data->vccq_mc0);
-}
-
 static const struct sh_pfc_soc_operations sh73a0_pinmux_ops = {
 	.init = sh73a0_pinmux_soc_init,
-	.exit = sh73a0_pinmux_soc_exit,
 	.get_bias = sh73a0_pinmux_get_bias,
 	.set_bias = sh73a0_pinmux_set_bias,
 };
-- 
1.9.1

