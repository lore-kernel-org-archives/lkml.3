Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbbA1Uhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:37:42 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46201 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbbA1Uhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:37:40 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: arm@kernel.org
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] ARM: multi_v7_defconfig: Enable Exynos5420 Multi-Cluster PM support
Date: Wed, 28 Jan 2015 15:40:20 +0100
Message-Id: <1422456020-10975-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos5420 cluster power management support allowing Exynos
5420/5422/5800 machines to power up and down the secondary CPUs.

Without this option enabled, the secondary CPUs are not brought
up on boot and the following error is shown:

CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x40938e90 - 0x40938f28
ARM CCI driver probed
CPU1: failed to boot: -38
CPU2: failed to boot: -38
CPU3: failed to boot: -38
CPU4: failed to boot: -38
CPU5: failed to boot: -38
CPU6: failed to boot: -38
CPU7: failed to boot: -38
Brought up 1 CPUs

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

This patch was tested on an Exynos5420 Peach Pit and with MCPM support
enabled, all the 8 CPUs are powered up:

Brought up 8 CPUs
SMP: Total of 8 processors activated (384.00 BogoMIPS).

 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 6e974b6bfa90..e8a4c955241b 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -61,6 +61,7 @@ CONFIG_MACH_SPEAR1310=y
 CONFIG_MACH_SPEAR1340=y
 CONFIG_ARCH_STI=y
 CONFIG_ARCH_EXYNOS=y
+CONFIG_EXYNOS5420_MCPM=y
 CONFIG_ARCH_SUNXI=y
 CONFIG_ARCH_SIRF=y
 CONFIG_ARCH_TEGRA=y
-- 
2.1.3

