Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3LNTSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:18:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:39505 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab3LNTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:18:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,486,1384329600"; 
   d="scan'208";a="424738999"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] x86: intel-mid: make X86_INTEL_MID depending on SFI
Date: Sat, 14 Dec 2013 11:23:24 -0800
Message-Id: <1387049004-21622-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite our intention to not make Intel MID dependent of SFI, it does
not reflect the current situation.
If SFI is not selected, Intel MID can't select APB_TIMER otherwise this
happens:

arch/x86/built-in.o: In function `apbt_set_mapping':
arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'
arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'

This patch solves such problem by adding SFI as dependence of
X86_INTEL_MID. As soon as we make Intel MID completely independent of
SFI this patch is safe to be reverted.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

This patch is intended to be applied on kernel 3.13-rc release.

As a matter of curiosity, CONFIG_APB_TIMER does depend on CONFIG_SFI. But looks
like CONFIG_X86_INTEL_MID is able to bypass it.
Maybe we need to check Kconfig itself too?

 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 00fa3b7d2abe..5802476d4e91 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -447,6 +447,7 @@ config X86_INTEL_MID
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
+	depends on SFI
 	select DW_APB_TIMER
 	select APB_TIMER
 	select INTEL_SCU_IPC
-- 
1.8.4.2

