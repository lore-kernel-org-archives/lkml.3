Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3BGU1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:27:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:60746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab3BGU1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:27:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="259266450"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix undefined wd symbols when MEI_ME is not set
Date: Thu,  7 Feb 2013 22:27:18 +0200
Message-Id: <1360268838-6947-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently watchdog client is compiled with MEI and not
with MEI_ME

Fixes error:
When CONFIG_WATCHDOG is not enabled:

ERROR: "watchdog_unregister_device" [drivers/misc/mei/mei.ko] undefined!
ERROR: "watchdog_register_device" [drivers/misc/mei/mei.ko] undefined

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index fa5c249..d21b4d0 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -1,6 +1,6 @@
 config INTEL_MEI
 	tristate "Intel Management Engine Interface"
-	depends on X86 && PCI
+	depends on X86 && PCI && WATCHDOG_CORE
 	help
 	  The Intel Management Engine (Intel ME) provides Manageability,
 	  Security and Media services for system containing Intel chipsets.
-- 
1.7.4.4

