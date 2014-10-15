Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaJOVqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:46:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:65279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOVqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,727,1406617200"; 
   d="scan'208";a="619461533"
From: David Cohen <david.a.cohen@linux.intel.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] clocksource: CMT, MTU2 and TMU should depend on CONFIG_HAS_IOMEM
Date: Wed, 15 Oct 2014 14:46:58 -0700
Message-Id: <1413409618-14531-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource Renesas CMT, MTU2 and TMU use io memory which make them not
compilable on architectures without HAS_IOMEM such as UML.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/clocksource/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 90420600e1eb..cee555cefe79 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -175,7 +175,7 @@ config SYS_SUPPORTS_EM_STI
 
 config SH_TIMER_CMT
 	bool "Renesas CMT timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_CMT
 	help
 	  This enables build of a clocksource and clockevent driver for
@@ -184,7 +184,7 @@ config SH_TIMER_CMT
 
 config SH_TIMER_MTU2
 	bool "Renesas MTU2 timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_MTU2
 	help
 	  This enables build of a clockevent driver for the Multi-Function
@@ -193,7 +193,7 @@ config SH_TIMER_MTU2
 
 config SH_TIMER_TMU
 	bool "Renesas TMU timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_TMU
 	help
 	  This enables build of a clocksource and clockevent driver for
-- 
2.1.0

