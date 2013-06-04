Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3FDMm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:42:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54079 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:42:53 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <tony@atomide.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Fabio Stevam <festevam@gmail.com>
Subject: [PATCHv3 1/3] arm: introduce config HAS_BANDGAP
Date: Tue, 4 Jun 2013 08:42:09 -0400
Message-ID: <1370349729-10517-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <51ADDE7A.6090205@ti.com>
References: <51ADDE7A.6090205@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bandgap is a device used to measure temperature on
electronic equipments. It is widely used in digital
integrated circuits. It is based on the dependency
between silicon voltage and temperature.

This patch introduce HAS_BANDGAP config entry.
This config is a boolean value so that arch
code can flag if they feature a bandgap device.

This config entry follows the same idea behind
ARCH_HAS_CPUFREQ.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Fabio Stevam <festevam@gmail.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/Kconfig            | 3 +++
 arch/arm/mach-omap2/Kconfig | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d423d58..bcbdec9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -174,6 +174,9 @@ config ARCH_HAS_CPUFREQ
 	  and that the relevant menu configurations are displayed for
 	  it.
 
+config ARCH_HAS_BANDGAP
+	bool
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..8620ab5 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -4,6 +4,7 @@ config ARCH_OMAP
 config ARCH_OMAP2PLUS
 	bool "TI OMAP2/3/4/5 SoCs with device tree support" if (ARCH_MULTI_V6 || ARCH_MULTI_V7)
 	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_BANDGAP
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select ARCH_REQUIRE_GPIOLIB
-- 
1.8.2.1.342.gfa7285d

