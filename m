Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaAUSga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:36:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:8395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaAUSg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:36:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,696,1384329600"; 
   d="scan'208";a="442406413"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] x86: intel-mid: fix possible warning when selecting X86_INTEL_MID
Date: Tue, 21 Jan 2014 10:41:39 -0800
Message-Id: <1390329699-20782-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <52de5cc8.5oL87RQWKI3CsbWx%fengguang.wu@intel.com>
References: <52de5cc8.5oL87RQWKI3CsbWx%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning:

warning: (X86_INTEL_MID) selects INTEL_SCU_IPC which has unmet direct
dependencies (X86 && X86_PLATFORM_DEVICES && X86_INTEL_MID)

It happens because when selected, X86_INTEL_MID tries to select
INTEL_SCU_IPC regardless all its dependencies are met or not. This patch
fixes it by adding the missing X86_PLATFORM_DEVICES dependency to
X86_INTEL_MID.

Found-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index edcf80eda566..2e446035fe92 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -442,6 +442,7 @@ config X86_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	depends on X86_PLATFORM_DEVICES
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
-- 
1.8.4.2

