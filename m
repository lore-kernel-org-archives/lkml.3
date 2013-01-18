Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3ARNpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:45:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:62241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3ARNpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:45:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,492,1355126400"; 
   d="scan'208";a="249027376"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/3] x86: add support for Intel Low Power Subsystem
Date: Fri, 18 Jan 2013 15:45:59 +0200
Message-Id: <1358516761-20981-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are starting to see traditional SoC peripherals also in the x86 world in
chips like Intel Lynxpoint. Typically we already have a Linux driver for
the peripheral but it takes advantage of the common clk framework to
control and retrieve information about the peripheral clock.

So far there hasn't been a standard way on x86 to pass information such as
clock rate from whatever the configuration system is used to the driver,
but instead different variations have emerged, like adding this information
to the platform data.

Solve this by adding a new config option X86_INTEL_LPSS. If this is
selected we enable common clk framework (and everything else) that is
needed to support the Intel LPSS drivers.

Enabling common clk framework on x86 was originally proposed by Mark Brown.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..c8c9b14 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -454,6 +454,16 @@ config X86_MDFLD
 
 endif
 
+config X86_INTEL_LPSS
+	bool "Intel Low Power Subsystem Support"
+	depends on ACPI
+	select COMMON_CLK
+	---help---
+	  Select to build support for Intel Low Power Subsystem such as
+	  found on Intel Lynxpoint PCH. Selecting this option enables
+	  things like clock tree (common clock framework) which are needed
+	  by the LPSS peripheral drivers.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
-- 
1.7.10.4

