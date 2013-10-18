Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3JRAfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:35:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3JRAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:35:10 -0400
Date: Thu, 17 Oct 2013 17:35:00 -0700
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-66ac50137049b3d3fab39e5ae245e1562aee5acd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1382049336-21316-12-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-12-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86: intel-mid:
  Add section for sfi device table
Git-Commit-ID: 66ac50137049b3d3fab39e5ae245e1562aee5acd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 17:35:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66ac50137049b3d3fab39e5ae245e1562aee5acd
Gitweb:     http://git.kernel.org/tip/66ac50137049b3d3fab39e5ae245e1562aee5acd
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Thu, 17 Oct 2013 15:35:35 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Oct 2013 16:41:04 -0700

x86: intel-mid: Add section for sfi device table

When Intel mid uses SFI table to enumerate devices, it requires an extra
device table with further information about how to probe such devices.

This patch creates a section where the device table will stay if
CONFIG_X86_INTEL_MID is selected.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1382049336-21316-12-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
