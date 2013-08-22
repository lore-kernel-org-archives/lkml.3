Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3HVGaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:30:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59943 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3HVGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:30:13 -0400
Message-ID: <1377153008.18701.0.camel@phoenix>
Subject: [PATCH] pinctrl: palmas: PINCTRL_PALMAS needs to select PINMUX
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Thu, 22 Aug 2013 14:30:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error if !PINMUX.

  CC      drivers/pinctrl/pinctrl-palmas.o
drivers/pinctrl/pinctrl-palmas.c:741:21: error: variable 'palmas_pinmux_ops' has initializer but incomplete type
drivers/pinctrl/pinctrl-palmas.c:742:2: error: unknown field 'get_functions_count' specified in initializer
drivers/pinctrl/pinctrl-palmas.c:742:2: warning: excess elements in struct initializer [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:742:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:743:2: error: unknown field 'get_function_name' specified in initializer
drivers/pinctrl/pinctrl-palmas.c:743:2: warning: excess elements in struct initializer [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:743:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:744:2: error: unknown field 'get_function_groups' specified in initializer
drivers/pinctrl/pinctrl-palmas.c:744:2: warning: excess elements in struct initializer [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:744:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:745:2: error: unknown field 'enable' specified in initializer
drivers/pinctrl/pinctrl-palmas.c:745:2: warning: excess elements in struct initializer [enabled by default]
drivers/pinctrl/pinctrl-palmas.c:745:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
make[2]: *** [drivers/pinctrl/pinctrl-palmas.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 8542cd4..ae8b747 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -264,6 +264,7 @@ config PINCTRL_EXYNOS5440
 config PINCTRL_PALMAS
 	bool "Pinctrl driver for the PALMA Series MFD devices"
 	depends on OF && MFD_PALMAS
+	select PINMUX
 	select GENERIC_PINCONF
 	help
 	  Palmas device supports the configuration of pins for different
-- 
1.8.1.2



