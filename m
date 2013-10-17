Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762447Ab3JQSUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:20:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035Ab3JQSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:20:41 -0400
Date: Thu, 17 Oct 2013 11:20:07 -0700
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-bedc8013631804c61f873cca4117e7af8236285a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381896701-23476-12-git-send-email-david.a.cohen@linux.intel.com>
References: <1381896701-23476-12-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86: intel-mid:
  add section for sfi device table
Git-Commit-ID: bedc8013631804c61f873cca4117e7af8236285a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 11:20:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bedc8013631804c61f873cca4117e7af8236285a
Gitweb:     http://git.kernel.org/tip/bedc8013631804c61f873cca4117e7af8236285a
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Tue, 15 Oct 2013 21:11:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Oct 2013 17:16:49 -0700

x86: intel-mid: add section for sfi device table

When Intel mid uses SFI table to enumerate devices, it requires an extra
device table with further information about how to probe such devices.

This patch creates a section where the device table will stay if
CONFIG_X86_INTEL_MID is selected.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1381896701-23476-12-git-send-email-david.a.cohen@linux.intel.com
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
