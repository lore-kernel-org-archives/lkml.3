Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbaJUOf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:35:57 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35208 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaJUOf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:35:56 -0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] ARM: imx: refactor mxc_iomux_mode()
Date: Tue, 21 Oct 2014 18:35:51 +0400
Message-Id: <1413902151-20255-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor mxc_iomux_mode():
 - since it always returns 0 make it to return void
 - remove unnecessary ret variable
 - declare variables according to the kernel coding style

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 arch/arm/mach-imx/iomux-imx31.c | 8 ++++----
 arch/arm/mach-imx/iomux-mx3.h   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/iomux-imx31.c b/arch/arm/mach-imx/iomux-imx31.c
index 1657fe6..d6a3075 100644
--- a/arch/arm/mach-imx/iomux-imx31.c
+++ b/arch/arm/mach-imx/iomux-imx31.c
@@ -44,9 +44,11 @@ static unsigned long mxc_pin_alloc_map[NB_PORTS * 32 / BITS_PER_LONG];
 /*
  * set the mode for a IOMUX pin.
  */
-int mxc_iomux_mode(unsigned int pin_mode)
+void mxc_iomux_mode(unsigned int pin_mode)
 {
-	u32 field, l, mode, ret = 0;
+	u32 field;
+	u32 l;
+	u32 mode;
 	void __iomem *reg;
 
 	reg = IOMUXSW_MUX_CTL + (pin_mode & IOMUX_REG_MASK);
@@ -61,8 +63,6 @@ int mxc_iomux_mode(unsigned int pin_mode)
 	__raw_writel(l, reg);
 
 	spin_unlock(&gpio_mux_lock);
-
-	return ret;
 }
 
 /*
diff --git a/arch/arm/mach-imx/iomux-mx3.h b/arch/arm/mach-imx/iomux-mx3.h
index f79f78a..0a5adba 100644
--- a/arch/arm/mach-imx/iomux-mx3.h
+++ b/arch/arm/mach-imx/iomux-mx3.h
@@ -144,7 +144,7 @@ void mxc_iomux_set_gpr(enum iomux_gp_func, bool en);
  * It is called by the setup functions and should not be called directly anymore.
  * It is here visible for backward compatibility
  */
-int mxc_iomux_mode(unsigned int pin_mode);
+void mxc_iomux_mode(unsigned int pin_mode);
 
 #define IOMUX_PADNUM_MASK	0x1ff
 #define IOMUX_GPIONUM_SHIFT	9
-- 
1.9.1

