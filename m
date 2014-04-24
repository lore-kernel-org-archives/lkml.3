Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDXITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:19:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:6922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaDXITP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,917,1389772800"; 
   d="scan'208";a="423030745"
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] x86, hpet: Make boot_hpet_disable extern
Date: Thu, 24 Apr 2014 16:18:17 +0800
Message-Id: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET on some platform has accuracy problem. Making
"boot_hpet_disable" extern so that we can runtime disable
the HPET timer by using quirk to check the platform.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index b18df57..36f7125 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -63,6 +63,7 @@
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
+extern int boot_hpet_disable;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 8d80ae0..4177bfb 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -88,7 +88,7 @@ static inline void hpet_clear_mapping(void)
 /*
  * HPET command line enable / disable
  */
-static int boot_hpet_disable;
+int boot_hpet_disable;
 int hpet_force_user;
 static int hpet_verbose;
 
-- 
1.7.9.5

