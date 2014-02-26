Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaBZXnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:43:42 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64429 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaBZXnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:43:39 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: qcom: Enable basic support for Qualcomm platforms in multi_v7_defconfig
References: <1393360445-16923-1-git-send-email-galak@codeaurora.org>
Date: Wed, 26 Feb 2014 15:43:31 -0800
Message-ID: <7hy50xv3rw.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@codeaurora.org> writes:

> Enable support for the MSM8x60, MSM8960, and MSM8974 SoCs, clocks and
> serial console as part of the standard multi_v7_defconfig.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>
> I leave this to the arm-soc guys to apply because of possible conflicts
> with other updates to multi_v7_defconfig.

Seem to be a handful of !qcom changes here, probably resulting from a
run of 'make savedefconfig' without all the new changes in.

I've thinned this out to only the qcom changes and applied the following
to next/boards.  I think it's better to do any 'make savedefconfig'
cleanups as a separate, cleanup-only patch as needed.

Kevin


>From 60476e4ad5a1369467ab8a061ae8ce601478646d Mon Sep 17 00:00:00 2001
From: Kumar Gala <galak@codeaurora.org>
Date: Tue, 25 Feb 2014 14:34:05 -0600
Subject: [PATCH] ARM: qcom: Enable basic support for Qualcomm platforms in
 multi_v7_defconfig

Enable support for the MSM8x60, MSM8960, and MSM8974 SoCs, clocks and
serial console as part of the standard multi_v7_defconfig.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
[khilman: removed non-qcom changes]
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 56549f178fe3..64e850d4896c 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -33,6 +33,10 @@ CONFIG_SOC_OMAP5=y
 CONFIG_SOC_AM33XX=y
 CONFIG_SOC_DRA7XX=y
 CONFIG_SOC_AM43XX=y
+CONFIG_ARCH_QCOM=y
+CONFIG_ARCH_MSM8X60=y
+CONFIG_ARCH_MSM8960=y
+CONFIG_ARCH_MSM8974=y
 CONFIG_ARCH_ROCKCHIP=y
 CONFIG_ARCH_SOCFPGA=y
 CONFIG_PLAT_SPEAR=y
@@ -148,6 +152,8 @@ CONFIG_SERIAL_SIRFSOC_CONSOLE=y
 CONFIG_SERIAL_TEGRA=y
 CONFIG_SERIAL_IMX=y
 CONFIG_SERIAL_IMX_CONSOLE=y
+CONFIG_SERIAL_MSM=y
+CONFIG_SERIAL_MSM_CONSOLE=y
 CONFIG_SERIAL_VT8500=y
 CONFIG_SERIAL_VT8500_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
@@ -298,6 +304,10 @@ CONFIG_MFD_NVEC=y
 CONFIG_KEYBOARD_NVEC=y
 CONFIG_SERIO_NVEC_PS2=y
 CONFIG_NVEC_POWER=y
+CONFIG_COMMON_CLK_QCOM=y
+CONFIG_MSM_GCC_8660=y
+CONFIG_MSM_MMCC_8960=y
+CONFIG_MSM_MMCC_8974=y
 CONFIG_TEGRA_IOMMU_GART=y
 CONFIG_TEGRA_IOMMU_SMMU=y
 CONFIG_MEMORY=y
-- 
1.8.3

