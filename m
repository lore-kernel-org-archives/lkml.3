Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbaGXHIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:08:45 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:41681 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934061AbaGXHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:08:43 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm/mach-imx/iomux: Do not export symbol without public declaration
Date: Thu, 24 Jul 2014 09:05:21 +0200
Message-Id: <1406185521-30803-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iomux function declarations are in headers only accessible in this
directory. Thus those can't be used in any module. None of the
objects in this directory is tristate. Neither can the header be included
in out-of-tree modules.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 arch/arm/mach-imx/iomux-imx31.c | 7 -------
 arch/arm/mach-imx/iomux-v1.c    | 2 --
 arch/arm/mach-imx/iomux-v3.c    | 2 --
 3 files changed, 11 deletions(-)

diff --git a/arch/arm/mach-imx/iomux-imx31.c b/arch/arm/mach-imx/iomux-imx31.c
index 7c66805d2cc0..1657fe64cd0f 100644
--- a/arch/arm/mach-imx/iomux-imx31.c
+++ b/arch/arm/mach-imx/iomux-imx31.c
@@ -64,7 +64,6 @@ int mxc_iomux_mode(unsigned int pin_mode)
 
 	return ret;
 }
-EXPORT_SYMBOL(mxc_iomux_mode);
 
 /*
  * This function configures the pad value for a IOMUX pin.
@@ -90,7 +89,6 @@ void mxc_iomux_set_pad(enum iomux_pins pin, u32 config)
 
 	spin_unlock(&gpio_mux_lock);
 }
-EXPORT_SYMBOL(mxc_iomux_set_pad);
 
 /*
  * allocs a single pin:
@@ -116,7 +114,6 @@ int mxc_iomux_alloc_pin(unsigned int pin, const char *label)
 
 	return 0;
 }
-EXPORT_SYMBOL(mxc_iomux_alloc_pin);
 
 int mxc_iomux_setup_multiple_pins(const unsigned int *pin_list, unsigned count,
 		const char *label)
@@ -137,7 +134,6 @@ setup_error:
 	mxc_iomux_release_multiple_pins(pin_list, i);
 	return ret;
 }
-EXPORT_SYMBOL(mxc_iomux_setup_multiple_pins);
 
 void mxc_iomux_release_pin(unsigned int pin)
 {
@@ -146,7 +142,6 @@ void mxc_iomux_release_pin(unsigned int pin)
 	if (pad < (PIN_MAX + 1))
 		clear_bit(pad, mxc_pin_alloc_map);
 }
-EXPORT_SYMBOL(mxc_iomux_release_pin);
 
 void mxc_iomux_release_multiple_pins(const unsigned int *pin_list, int count)
 {
@@ -158,7 +153,6 @@ void mxc_iomux_release_multiple_pins(const unsigned int *pin_list, int count)
 		p++;
 	}
 }
-EXPORT_SYMBOL(mxc_iomux_release_multiple_pins);
 
 /*
  * This function enables/disables the general purpose function for a particular
@@ -178,4 +172,3 @@ void mxc_iomux_set_gpr(enum iomux_gp_func gp, bool en)
 	__raw_writel(l, IOMUXGPR);
 	spin_unlock(&gpio_mux_lock);
 }
-EXPORT_SYMBOL(mxc_iomux_set_gpr);
diff --git a/arch/arm/mach-imx/iomux-v1.c b/arch/arm/mach-imx/iomux-v1.c
index 2b156d1d9e21..ecd543664644 100644
--- a/arch/arm/mach-imx/iomux-v1.c
+++ b/arch/arm/mach-imx/iomux-v1.c
@@ -153,7 +153,6 @@ int mxc_gpio_mode(int gpio_mode)
 
 	return 0;
 }
-EXPORT_SYMBOL(mxc_gpio_mode);
 
 static int imx_iomuxv1_setup_multiple(const int *list, unsigned count)
 {
@@ -178,7 +177,6 @@ int mxc_gpio_setup_multiple_pins(const int *pin_list, unsigned count,
 	ret = imx_iomuxv1_setup_multiple(pin_list, count);
 	return ret;
 }
-EXPORT_SYMBOL(mxc_gpio_setup_multiple_pins);
 
 int __init imx_iomuxv1_init(void __iomem *base, int numports)
 {
diff --git a/arch/arm/mach-imx/iomux-v3.c b/arch/arm/mach-imx/iomux-v3.c
index 9dae74bf47fc..d61f9606fc56 100644
--- a/arch/arm/mach-imx/iomux-v3.c
+++ b/arch/arm/mach-imx/iomux-v3.c
@@ -55,7 +55,6 @@ int mxc_iomux_v3_setup_pad(iomux_v3_cfg_t pad)
 
 	return 0;
 }
-EXPORT_SYMBOL(mxc_iomux_v3_setup_pad);
 
 int mxc_iomux_v3_setup_multiple_pads(iomux_v3_cfg_t *pad_list, unsigned count)
 {
@@ -71,7 +70,6 @@ int mxc_iomux_v3_setup_multiple_pads(iomux_v3_cfg_t *pad_list, unsigned count)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mxc_iomux_v3_setup_multiple_pads);
 
 void mxc_iomux_v3_init(void __iomem *iomux_v3_base)
 {
-- 
1.8.5.5

