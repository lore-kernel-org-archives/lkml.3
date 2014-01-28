Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaA1XEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:04:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:33448 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbaA1XEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:04:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,739,1384329600"; 
   d="scan'208";a="474034946"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] x86: intel-mid: cleanup some platform code's header files
Date: Tue, 28 Jan 2014 15:09:27 -0800
Message-Id: <1390950567-12821-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <20140128193515.GB11722@psi-dev26.jf.intel.com>
References: <20140128193515.GB11722@psi-dev26.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_ipc.h and platform_msic.h are wrongly declaring functions as
external and with 'weak' attribute. This patch does a cleanup on those
header files.

It should have no functional change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_ipc.h  | 5 +++--
 arch/x86/platform/intel-mid/device_libs/platform_msic.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
index 8f568dd79605..79bb09d4f718 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
@@ -12,6 +12,7 @@
 #ifndef _PLATFORM_IPC_H_
 #define _PLATFORM_IPC_H_
 
-extern void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-			struct devs_id *dev) __attribute__((weak));
+void __init
+ipc_device_handler(struct sfi_device_table_entry *pentry, struct devs_id *dev);
+
 #endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.h b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
index 917eb56d77da..b7be1d041da2 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
@@ -14,6 +14,6 @@
 
 extern struct intel_msic_platform_data msic_pdata;
 
-extern void *msic_generic_platform_data(void *info,
-			enum intel_msic_block block) __attribute__((weak));
+void *msic_generic_platform_data(void *info, enum intel_msic_block block);
+
 #endif
-- 
1.8.4.2

