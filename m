Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029Ab3JQVxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:53:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:42531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762930Ab3JQVwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:52:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="394625569"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v9 13/14] x86: intel-mid: add section for sfi device table
Date: Thu, 17 Oct 2013 14:55:56 -0700
Message-Id: <1382046957-15987-14-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382046957-15987-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382046957-15987-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Intel mid uses SFI table to enumerate devices, it requires an extra
device table with further information about how to probe such devices.

This patch creates a section where the device table will stay if
CONFIG_X86_INTEL_MID is selected.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/kernel/vmlinux.lds.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 10c4f30..da6b35a 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -199,6 +199,15 @@ SECTIONS
 		__x86_cpu_dev_end = .;
 	}
 
+#ifdef CONFIG_X86_INTEL_MID
+	.x86_intel_mid_dev.init : AT(ADDR(.x86_intel_mid_dev.init) - \
+								LOAD_OFFSET) {
+		__x86_intel_mid_dev_start = .;
+		*(.x86_intel_mid_dev.init)
+		__x86_intel_mid_dev_end = .;
+	}
+#endif
+
 	/*
 	 * start address and size of operations which during runtime
 	 * can be patched with virtualization friendly instructions or
-- 
1.8.4.rc3

