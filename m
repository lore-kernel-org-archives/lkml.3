Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBJMex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:34:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:29550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaBJMes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:34:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="472729231"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix compilation error with missing WATCHDOG_CORE
Date: Mon, 10 Feb 2014 14:33:53 +0200
Message-Id: <1392035633-21602-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig is not transitive so INTEL_ME_TXE has to depend
on WATCHDOG_CORE as well

ERROR: "watchdog_unregister_device" [drivers/misc/mei/mei.ko]
undefined!
ERROR: "watchdog_register_device" [drivers/misc/mei/mei.ko]
undefined!

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index 5881679..d23384d 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -37,7 +37,7 @@ config INTEL_MEI_ME
 config INTEL_MEI_TXE
 	tristate "Intel Trusted Execution Environment with ME Interface"
 	select INTEL_MEI
-	depends on X86 && PCI
+	depends on X86 && PCI && WATCHDOG_CORE
 	help
 	  MEI Support for Trusted Execution Environment device on Intel SoCs
 
-- 
1.8.5.3

