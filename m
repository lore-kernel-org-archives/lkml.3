Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaAYO0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:26:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaAYO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:26:05 -0500
Date: Sat, 25 Jan 2014 06:25:50 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-edc6bc784028f2ef80dff0ff697363ff5a06e3a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <1390329699-20782-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1390329699-20782-1-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel/mid: Fix X86_INTEL_MID dependencies
Git-Commit-ID: edc6bc784028f2ef80dff0ff697363ff5a06e3a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:25:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edc6bc784028f2ef80dff0ff697363ff5a06e3a3
Gitweb:     http://git.kernel.org/tip/edc6bc784028f2ef80dff0ff697363ff5a06e3a3
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Tue, 21 Jan 2014 10:41:39 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:17:32 +0100

x86/intel/mid: Fix X86_INTEL_MID dependencies

This patch fixes the following warning:

  warning: (X86_INTEL_MID) selects INTEL_SCU_IPC which has unmet direct dependencies (X86 && X86_PLATFORM_DEVICES && X86_INTEL_MID)

It happens because when selected, X86_INTEL_MID tries to select
INTEL_SCU_IPC regardless all its dependencies are met or not.

This patch fixes it by adding the missing X86_PLATFORM_DEVICES
dependency to X86_INTEL_MID.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1390329699-20782-1-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9af47..3b6922e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -443,6 +443,7 @@ config X86_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	depends on X86_PLATFORM_DEVICES
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
