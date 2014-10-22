Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaJVU6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:58:39 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:33900 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976AbaJVU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:58:36 -0400
X-IronPort-AV: E=Sophos;i="5.04,771,1406617200"; 
   d="scan'208";a="48759418"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Scott Branden <sbranden@broadcom.com>
Subject: [PATCH v7 7/7] ARM: mach-bcm: ARCH_BCM_MOBILE: remove one level of menu from Kconfig
Date: Wed, 22 Oct 2014 13:57:54 -0700
Message-ID: <1414011474-11821-8-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414011474-11821-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414011474-11821-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove menu "Broadcom Mobile SoC Selection"
This requires:
- selecting ARCH_BCM_MOBILE based on SoC selections
- fixup bcm_defconfig to work with new menu levels.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/configs/bcm_defconfig      |    3 ++-
 arch/arm/configs/multi_v7_defconfig |    3 ++-
 arch/arm/mach-bcm/Kconfig           |   26 ++++++++++----------------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index bc614f4..83a87e4 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -25,7 +25,8 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARCH_BCM=y
-CONFIG_ARCH_BCM_MOBILE=y
+CONFIG_ARCH_BCM_21664=y
+CONFIG_ARCH_BCM_281XX=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 491b7d5..e8f79fd 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -17,7 +17,8 @@ CONFIG_MACH_ARMADA_38X=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_MACH_DOVE=y
 CONFIG_ARCH_BCM=y
-CONFIG_ARCH_BCM_MOBILE=y
+CONFIG_ARCH_BCM_21664=y
+CONFIG_ARCH_BCM_281XX=y
 CONFIG_ARCH_BCM_5301X=y
 CONFIG_ARCH_BRCMSTB=y
 CONFIG_ARCH_BERLIN=y
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 6e79696..cceb69f 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -51,8 +51,10 @@ config ARCH_BCM_5301X
 	  different SoC or with the older BCM47XX and BCM53XX based
 	  network SoC using a MIPS CPU, they are supported by arch/mips/bcm47xx
 
+comment "KONA architected SoCs"
+
 config ARCH_BCM_MOBILE
-	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
+	bool
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_775420
@@ -61,16 +63,13 @@ config ARCH_BCM_MOBILE
 	select TICK_ONESHOT
 	select HAVE_ARM_ARCH_TIMER
 	select PINCTRL
+	select ARCH_BCM_MOBILE_SMP if SMP
 	help
 	  This enables support for systems based on Broadcom mobile SoCs.
 
-if ARCH_BCM_MOBILE
-
-menu "Broadcom Mobile SoC Selection"
-
 config ARCH_BCM_281XX
 	bool "Broadcom BCM281XX SoC family"
-	default y
+	select ARCH_BCM_MOBILE
 	select HAVE_SMP
 	help
 	  Enable support for the BCM281XX family, which includes
@@ -79,7 +78,7 @@ config ARCH_BCM_281XX
 
 config ARCH_BCM_21664
 	bool "Broadcom BCM21664 SoC family"
-	default y
+	select ARCH_BCM_MOBILE
 	select HAVE_SMP
 	help
 	  Enable support for the BCM21664 family, which includes
@@ -87,19 +86,18 @@ config ARCH_BCM_21664
 
 config ARCH_BCM_MOBILE_L2_CACHE
 	bool "Broadcom mobile SoC level 2 cache support"
-	depends on (ARCH_BCM_281XX || ARCH_BCM_21664)
+	depends on ARCH_BCM_MOBILE
 	default y
 	select CACHE_L2X0
 	select ARCH_BCM_MOBILE_SMC
 
 config ARCH_BCM_MOBILE_SMC
 	bool
-	depends on ARCH_BCM_281XX || ARCH_BCM_21664
+	depends on ARCH_BCM_MOBILE
 
 config ARCH_BCM_MOBILE_SMP
-	bool "Broadcom mobile SoC SMP support"
-	depends on (ARCH_BCM_281XX || ARCH_BCM_21664) && SMP
-	default y
+	bool
+	depends on ARCH_BCM_MOBILE
 	select HAVE_ARM_SCU
 	select ARM_ERRATA_764369
 	help
@@ -107,10 +105,6 @@ config ARCH_BCM_MOBILE_SMP
 	  Provided as an option so SMP support for SoCs of this type
 	  can be disabled for an SMP-enabled kernel.
 
-endmenu
-
-endif
-
 comment "Other Architectures"
 
 config ARCH_BCM2835
-- 
1.7.9.5

