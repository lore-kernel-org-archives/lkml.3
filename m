Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaAUKLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:11:45 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7016 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaAUKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:10:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Jan 2014 02:10:00 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/5] ARM: firmware: enable Trusted Foundations by default
Date: Tue, 21 Jan 2014 19:10:14 +0900
Message-ID: <1390299016-14105-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed previously (https://lkml.org/lkml/2013/11/26/289), enable
Trusted Foundation support by default since it already depends on a
supporting architecture being selected.

Doing so allows us to remove it from tegra_defconfig.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/configs/tegra_defconfig | 1 -
 arch/arm/firmware/Kconfig        | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 5fdc9a09d339..e38653876541 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -33,7 +33,6 @@ CONFIG_PCI=y
 CONFIG_PCI_MSI=y
 CONFIG_PCI_TEGRA=y
 CONFIG_PCIEPORTBUS=y
-CONFIG_TRUSTED_FOUNDATIONS=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
index bb126594995e..ad396af68e47 100644
--- a/arch/arm/firmware/Kconfig
+++ b/arch/arm/firmware/Kconfig
@@ -11,6 +11,7 @@ menu "Firmware options"
 config TRUSTED_FOUNDATIONS
 	bool "Trusted Foundations secure monitor support"
 	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	default y
 	help
 	  Some devices (including most Tegra-based consumer devices on the
 	  market) are booted with the Trusted Foundations secure monitor
-- 
1.8.5.3

