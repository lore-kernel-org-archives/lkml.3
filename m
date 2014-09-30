Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaI3RQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:16:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55081 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI3RQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:16:45 -0400
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>, Jyri Sarha <jsarha@ti.com>
Cc: linux-kernel@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@kernel.org>
Date: Tue, 30 Sep 2014 18:16:22 +0100
Message-Id: <1412097382-8351-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] clk: gpio-gate: Ensure gpiod_ APIs are prototyped
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio-gate clock uses the gpiod_ APIs but does not directly include the
header for them causing build failures in some configurations including ARM
allnoconfig. Include the header directly.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/clk/clk-gpio-gate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
index 9dde88533684..08e43224fd52 100644
--- a/drivers/clk/clk-gpio-gate.c
+++ b/drivers/clk/clk-gpio-gate.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_gpio.h>
 #include <linux/err.h>
 #include <linux/device.h>
-- 
2.1.1

