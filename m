Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3FFMXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:23:12 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53721 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab3FFMSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 18/33] clk: ux500: Add a 2-cell Device Tree parser for obtaining PRCC clocks
Date: Thu,  6 Jun 2013 13:17:06 +0100
Message-Id: <1370521041-32318-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRCC (peripheral and kernel) clocks are specified using a property tuple
<&phandle base bit>, where 'base' is the peripheral (1, 2, 3, 5 or 6),
and bit is read-in value into that peripheral stipulated by the hardware
specification.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index ef948ff..3a7040b 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -15,6 +15,25 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk **clk_data = data;
+	unsigned int base, bit;
+
+	if (clkspec->args_count != 2)
+		return  ERR_PTR(-EINVAL);
+
+	base = clkspec->args[0];
+	bit = clkspec->args[1];
+
+	if (base != 1 && base != 2 && base != 3 && base != 5 && base != 6) {
+		pr_err("%s: invalid PRCC base %d\n", __func__, base);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return PRCC_SHOW(clk_data, base, bit);
+}
+
 const static struct of_device_id u8500_clk_of_match[] = {
        { .compatible = "stericsson,u8500-clks", },
        { },
-- 
1.7.10.4

