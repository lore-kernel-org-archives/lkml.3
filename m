Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaIPEYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:24:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54018 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaIPEYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:24:37 -0400
From: Martin Kelly <martin@martingkelly.com>
To: x86@kernel.org
Cc: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        aubrey.li@linux.intel.com, linux-kernel@vger.kernel.org,
        Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
Date: Mon, 15 Sep 2014 21:24:23 -0700
Message-Id: <1410841463-24826-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
warning for pmc_atom.c because "ret" is used only within the
CONFIG_DEBUG_FS block. This patch fixes it up to eliminate "ret" when
CONFIG_DEBUG_FS=n.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 arch/x86/kernel/pmc_atom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0c424a6..66e7d88 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -240,7 +240,9 @@ err:
 static int pmc_setup_dev(struct pci_dev *pdev)
 {
 	struct pmc_dev *pmc = &pmc_device;
+#ifdef CONFIG_DEBUG_FS
 	int ret;
+#endif /* CONFIG_DEBUG_FS */
 
 	/* Obtain ACPI base address */
 	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
-- 
2.1.0

