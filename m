Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3IIC1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:27:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:55683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3IIC1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="398540923"
Subject: [PATCH] reboot: re-enable the function of variable reboot_default
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@kernel.org, holt@sgi.com, hpa@zytor.com, rmk+kernel@arm.linux.org.uk,
        rja@sgi.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fei.li@intel.com, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Sep 2013 19:49:40 +0800
Message-ID: <1378727380.26153.8.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit b3a5d02ee070c(reboot: move arch/x86 reboot= handling to generic kernel)
did some cleanup for reboot= command line, but it made the reboot_default
to be invalidated.

The default value of variable reboot_default should be 1, and if command line
reboot= is not set, system will use the default reboot mode.

Signed-off-by: Li Fei <fei.li@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/reboot.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 269ed93..d82eb6e 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -32,7 +32,14 @@ EXPORT_SYMBOL(cad_pid);
 #endif
 enum reboot_mode reboot_mode DEFAULT_REBOOT_MODE;
 
-int reboot_default;
+/*
+ * This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+*/
+int reboot_default = 1;
 int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
-- 
1.7.0.4



