Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3AUW24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:28:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:32957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab3AUW2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:28:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,508,1355126400"; 
   d="scan'208";a="280089655"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/2] NTB: disable x86_32 support
Date: Mon, 21 Jan 2013 15:28:51 -0700
Message-Id: <1358807332-22782-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic readq and writeq do not exist by default on some 32bit
architectures, thus causing compile errors due to non-existent symbols.
Since NTB has not been tested 32bit, disable x86_32 support until such
time as this and any other issues can be properly discovered.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/Kconfig b/drivers/ntb/Kconfig
index f69df793..37ee649 100644
--- a/drivers/ntb/Kconfig
+++ b/drivers/ntb/Kconfig
@@ -1,7 +1,7 @@
 config NTB
        tristate "Intel Non-Transparent Bridge support"
        depends on PCI
-       depends on X86
+       depends on X86_64
        help
         The PCI-E Non-transparent bridge hardware is a point-to-point PCI-E bus
         connecting 2 systems.  When configured, writes to the device's PCI
-- 
1.7.9.5

