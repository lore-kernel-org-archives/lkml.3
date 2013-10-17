Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab3JQWeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:34:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:3046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3JQWbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:31:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="420869462"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v10 04/12] pci: intel_mid: return true/false in function returning bool
Date: Thu, 17 Oct 2013 15:35:28 -0700
Message-Id: <1382049336-21316-5-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Function 'type1_access_ok' should return bool value, not 0/1.
This patch changes 'return 0/1' to 'return false/true'.

Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/pci/intel_mid_pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index f8715f7..c5ca5b9 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -150,12 +150,12 @@ static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 	 * shim. Therefore, use the header type in shim instead.
 	 */
 	if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
-		return 0;
+		return false;
 	if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
 				|| devfn == PCI_DEVFN(0, 0)
 				|| devfn == PCI_DEVFN(3, 0)))
-		return 1;
-	return 0; /* Langwell on others */
+		return true;
+	return false; /* Langwell on others */
 }
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
-- 
1.8.4.rc3

