Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab3IMN7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:59:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:25522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab3IMN7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:59:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="377718584"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: x86@kernel.org
Cc: <linux-kernel@vger.kernel.org>, <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] x86: add pin control support to Intel low power subsystem
Date: Fri, 13 Sep 2013 17:02:29 +0300
Message-Id: <1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 chips with LPSS (low power subsystem) such as Lynxpoint and
Baytrail have SoC like peripheral support and controllable pins.

At the moment, Baytrail needs the pinctrl-baytrail driver to let
peripherals control their gpio resources, but more pincontrol functions
such as pin muxing and grouping are possible to add later.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 arch/x86/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30c40f0..91f72b5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -482,11 +482,12 @@ config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
 	depends on ACPI
 	select COMMON_CLK
+	select PINCTRL
 	---help---
 	  Select to build support for Intel Low Power Subsystem such as
 	  found on Intel Lynxpoint PCH. Selecting this option enables
-	  things like clock tree (common clock framework) which are needed
-	  by the LPSS peripheral drivers.
+	  things like clock tree (common clock framework) and pincontrol
+	  which are needed by the LPSS peripheral drivers.
 
 config X86_RDC321X
 	bool "RDC R-321x SoC"
-- 
1.7.4.1

