Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3J2WiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:38:14 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3J2Whl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:37:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/19] pinctrl: sh-pfc: Enable the driver on all ARM platforms
Date: Tue, 29 Oct 2013 23:37:48 +0100
Message-Id: <1383086274-11049-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1383086274-11049-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1383086274-11049-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas ARM platforms are transitioning from single-platform to
multi-platform kernels using the new ARCH_SHMOBILE_MULTI. Make the
driver available on all ARM platforms to enable it on both ARCH_SHMOBILE
and ARCH_SHMOBILE_MULTI and increase build testing coverage.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/Makefile       | 2 +-
 drivers/pinctrl/sh-pfc/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 496d9bf..bef5a9f 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -56,7 +56,7 @@ obj-$(CONFIG_PINCTRL_ST) 	+= pinctrl-st.o
 obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
 
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
-obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
+obj-$(CONFIG_ARM)		+= sh-pfc/
 obj-$(CONFIG_SUPERH)		+= sh-pfc/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_VT8500)	+= vt8500/
diff --git a/drivers/pinctrl/sh-pfc/Kconfig b/drivers/pinctrl/sh-pfc/Kconfig
index 636a882..1d6182e 100644
--- a/drivers/pinctrl/sh-pfc/Kconfig
+++ b/drivers/pinctrl/sh-pfc/Kconfig
@@ -2,7 +2,7 @@
 # Renesas SH and SH Mobile PINCTRL drivers
 #
 
-if ARCH_SHMOBILE || SUPERH
+if ARM || SUPERH
 
 config PINCTRL_SH_PFC
 	select GPIO_SH_PFC if ARCH_REQUIRE_GPIOLIB
-- 
1.8.1.5

