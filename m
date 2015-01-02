Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbbABQLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:11:50 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60206 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbABQLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:11:48 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND] ARM: exynos_defconfig: Enable options for display panel support
Date: Fri,  2 Jan 2015 17:11:29 +0100
Message-Id: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Exynos devices have a display panel. Most of them just have
a simple panel while others have more complex configurations that
requires an embedded DisplayPort (eDP) to LVDS bridges.

This patch enables the following features to be built in the kernel
image to support both setups:

- Direct Rendering Manager (DRM)
- DRM bridge registration and lookup framework
- Parade ps8622/ps8625 eDP/LVDS bridge
- NXP ptn3460 eDP/LVDS bridge
- Exynos Fully Interactive Mobile Display controller (FIMD)
- Panel registration and lookup framework
- Simple panels
- Backlight & LCD device support

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---

Hello Kukjin,

You dropped this patch since exynos drm was causing boot hangs on some
platforms but the fix for that issue is already in linux-next (commit:
f1e9203 clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
failure due to domain being gated) so I think it makes sense to enable
the display options again.

NOTE: Display panel is still not working since patch "arm: dts: Exynos5:
Use pmu_system_controller phandle for dp phy" is needed [0] but I think
we should enable display options to catch the regressions easier.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/11/24/10

 arch/arm/configs/exynos_defconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 22beed3..27cdd52 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -111,11 +111,26 @@ CONFIG_REGULATOR_S2MPA01=y
 CONFIG_REGULATOR_S2MPS11=y
 CONFIG_REGULATOR_S5M8767=y
 CONFIG_REGULATOR_TPS65090=y
+CONFIG_DRM=y
+CONFIG_DRM_BRIDGE=y
+CONFIG_DRM_PTN3460=y
+CONFIG_DRM_PS8622=y
+CONFIG_DRM_EXYNOS=y
+CONFIG_DRM_EXYNOS_FIMD=y
+CONFIG_DRM_EXYNOS_DP=y
+CONFIG_DRM_PANEL=y
+CONFIG_DRM_PANEL_SIMPLE=y
 CONFIG_FB=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_SIMPLE=y
 CONFIG_EXYNOS_VIDEO=y
 CONFIG_EXYNOS_MIPI_DSI=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_LCD_CLASS_DEVICE=y
+CONFIG_LCD_PLATFORM=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
+CONFIG_BACKLIGHT_GENERIC=y
+CONFIG_BACKLIGHT_PWM=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FONTS=y
 CONFIG_FONT_7x14=y
-- 
2.1.3

