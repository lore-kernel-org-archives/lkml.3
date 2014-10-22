Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaJVCK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:10:28 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9512 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaJVCKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:10:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,766,1406617200"; 
   d="scan'208";a="48677224"
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
Subject: [PATCH v6 6/6] ARM: mach-bcm: Consolidate currently supported IPROC SoCs
Date: Tue, 21 Oct 2014 19:09:52 -0700
Message-ID: <1413943792-7379-7-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413943792-7379-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1413943792-7379-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ARCH_BCM_5301X subarch under ARCH_IPROC architecture.
Additional IPROC chipsets that share a lot of commonality should be
added under ARCH_IPROC as well.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/mach-bcm/Kconfig |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index f5e638e..a51f191 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -33,6 +33,22 @@ config ARCH_BCM_CYGNUS
 	  BCM11300, BCM11320, BCM11350, BCM11360,
 	  BCM58300, BCM58302, BCM58303, BCM58305.
 
+config ARCH_BCM_5301X
+	bool "Broadcom BCM470X / BCM5301X ARM SoC" if ARCH_MULTI_V7
+	select ARCH_BCM_IPROC
+	help
+	  Support for Broadcom BCM470X and BCM5301X SoCs with ARM CPU cores.
+
+	  This is a network SoC line mostly used in home routers and
+	  wifi access points, it's internal name is Northstar.
+	  This inclused the following SoC: BCM53010, BCM53011, BCM53012,
+	  BCM53014, BCM53015, BCM53016, BCM53017, BCM53018, BCM4707,
+	  BCM4708 and BCM4709.
+
+	  Do not confuse this with the BCM4760 which is a totally
+	  different SoC or with the older BCM47XX and BCM53XX based
+	  network SoC using a MIPS CPU, they are supported by arch/mips/bcm47xx
+
 config ARCH_BCM_MOBILE
 	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
 	select ARCH_REQUIRE_GPIOLIB
@@ -106,27 +122,6 @@ config ARCH_BCM2835
 	  This enables support for the Broadcom BCM2835 SoC. This SoC is
 	  used in the Raspberry Pi and Roku 2 devices.
 
-config ARCH_BCM_5301X
-	bool "Broadcom BCM470X / BCM5301X ARM SoC" if ARCH_MULTI_V7
-	select ARM_GIC
-	select CACHE_L2X0
-	select HAVE_ARM_SCU if SMP
-	select HAVE_ARM_TWD if SMP
-	select ARM_GLOBAL_TIMER
-	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-	help
-	  Support for Broadcom BCM470X and BCM5301X SoCs with ARM CPU cores.
-
-	  This is a network SoC line mostly used in home routers and
-	  wifi access points, it's internal name is Northstar.
-	  This inclused the following SoC: BCM53010, BCM53011, BCM53012,
-	  BCM53014, BCM53015, BCM53016, BCM53017, BCM53018, BCM4707,
-	  BCM4708 and BCM4709.
-
-	  Do not confuse this with the BCM4760 which is a totally
-	  different SoC or with the older BCM47XX and BCM53XX based
-	  network SoC using a MIPS CPU, they are supported by arch/mips/bcm47xx
-
 config ARCH_BCM_63XX
 	bool "Broadcom BCM63xx DSL SoC" if ARCH_MULTI_V7
 	depends on MMU
-- 
1.7.9.5

