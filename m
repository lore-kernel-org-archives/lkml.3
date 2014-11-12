Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaKLTEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:04:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:10085 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaKLTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:04:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="635914301"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>
Cc: Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] powercap/rapl: fix build dependency on iosf_mbi
Date: Wed, 12 Nov 2014 10:50:36 -0800
Message-Id: <1415818236-21741-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAPL on Atom depends on IOSF_MBI driver for setting
floor frequency. This patch adds explicit dependency on
CONFIG_IOSF_MB.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/Kconfig b/drivers/powercap/Kconfig
index a7c81b5..85727ef 100644
--- a/drivers/powercap/Kconfig
+++ b/drivers/powercap/Kconfig
@@ -17,7 +17,7 @@ if POWERCAP
 # Client driver configurations go here.
 config INTEL_RAPL
 	tristate "Intel RAPL Support"
-	depends on X86
+	depends on X86 && IOSF_MBI
 	default n
 	---help---
 	  This enables support for the Intel Running Average Power Limit (RAPL)
-- 
1.9.1

