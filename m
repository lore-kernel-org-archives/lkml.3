Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025Ab3BNW1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:27:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268Ab3BNW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Maxime Ripard <maxime.ripard@anandra.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/9] clk: sunxi: remove stale Makefile entry
Date: Thu, 14 Feb 2013 23:26:52 +0100
Message-Id: <1360880818-4071454-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:FOlEvnxYGbTkVrkkj8SHmmn49QTrPvi8ocFpTVkRUNj
 3YxvV6ICp7PG+Y+ZcP4QE3iXOU79Nsxj2O4WhoA+yTqmEfy7X/
 3MCbMsM5J9hLw8cOLpgW41B8YklIdu+IuOcOB8D6kqHzykou13
 QWQ8cQjHD+SHAFuay1rxxDGNHojwjU6z5o293xOlPEVrK460u8
 K13XpOh1q8cnk85njqMegQd5OqIDOmGFTQddFrPxBgLT5ZXr18
 EpeJf+ljbvxdi+y2dpX8cz3qfLR4Bbfo2i9dP+jxKdE8ZU96Iu
 iellkIbPDoR98rjLCLDy4f77qWE860Hj/l3ToRXOSgcmNiJX3d
 m212ImpN42Qph8OGjeZu1yJanEbTSRcT9aJF51Vpg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 85a18198 "clk: sunxi: Use common of_clk_init() function"
removed the clk-sunxi.c file but left the Makefile entry, which
causes a build error in multi_v7_defconfig:

make[4]: *** No rule to make target `drivers/clk/clk-sunxi.o', needed by `drivers/clk/built-in.o'.

The obvious fix is to remove the extraneous line from the
Makefile.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Maxime Ripard <maxime.ripard@anandra.org>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index ce77077..be9392e 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -25,7 +25,6 @@ endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
-obj-$(CONFIG_ARCH_SUNXI)	+= clk-sunxi.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
-- 
1.8.1.2

