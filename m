Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaE0VLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:11:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:62679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaE0VLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,922,1392192000"; 
   d="scan'208";a="518608608"
From: David Cohen <david.a.cohen@intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, David Cohen <david.a.cohen@intel.com>
Subject: [PATCH] x86: intel-mid: fix watchdog platform code
Date: Tue, 27 May 2014 14:11:06 -0700
Message-Id: <1401225066-28786-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140526211820.GB23751@spo001.leaseweb.com>
References: <20140526211820.GB23751@spo001.leaseweb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes missing include asm/io_apic.h which may lead to
following error:

   arch/x86/platform/intel-mid/device_libs/platform_wdt.c: In function 'tangier_probe':
>> arch/x86/platform/intel-mid/device_libs/platform_wdt.c:37:2: error: implicit declaration of function 'mp_find_ioapic' [-Werror=implicit-function-declaration]
     ioapic = mp_find_ioapic(irq);
     ^
>> arch/x86/platform/intel-mid/device_libs/platform_wdt.c:44:3: error: implicit declaration of function 'io_apic_set_pci_routing' [-Werror=implicit-function-declaration]
      ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
      ^
Signed-off-by: David Cohen <david.a.cohen@intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
index a05315eb052d..973cf3bfa9fd 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/intel-mid_wdt.h>
 #include <asm/intel-mid.h>
+#include <asm/io_apic.h>
 
 #define TANGIER_EXT_TIMER0_MSI 15
 
-- 
1.9.1

