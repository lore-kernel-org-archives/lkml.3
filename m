Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3CKOIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:08:14 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52266 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3CKOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:08:13 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:08:12 +0800
Message-ID: <CAPgLHd-SZw14C_jDYrGNyYWJ7XafX--NEaF9+QofAcm9CuFK_w@mail.gmail.com>
Subject: [PATCH -next] sh-pfc: fix return value check in sh_pfc_register_pinctrl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, lethal@linux-sh.org,
        laurent.pinchart+renesas@ideasonboard.com, horms+renesas@verge.net.au
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function pinctrl_register() returns
NULL not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/sh-pfc/pinctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 11e0e13..271e2c1 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -439,8 +439,8 @@ int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
 		return ret;
 
 	pmx->pctl = pinctrl_register(&sh_pfc_pinctrl_desc, pfc->dev, pmx);
-	if (IS_ERR(pmx->pctl))
-		return PTR_ERR(pmx->pctl);
+	if (!pmx->pctl)
+		return -EINVAL;
 
 	sh_pfc_gpio_range.npins = pfc->info->last_gpio
 				- pfc->info->first_gpio + 1;

