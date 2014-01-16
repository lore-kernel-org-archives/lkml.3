Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaAPWp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:45:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35611 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAPWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:45:19 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH] pinctrl: capri: add dependency on OF
Date: Thu, 16 Jan 2014 23:45:12 +0100
Message-Id: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this driver is using pinconf_generic_dt_node_to_map_pin() it
needs to depend on OF so as not to cause build problems on
archs that do not support OF.

Cc: Sherman Yin <syin@broadcom.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f1dda4d9de13..be361b7cd30f 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -106,6 +106,7 @@ config PINCTRL_BCM2835
 
 config PINCTRL_CAPRI
 	bool "Broadcom Capri pinctrl driver"
+	depends on OF
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
-- 
1.8.4.2

