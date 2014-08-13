Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaHMGzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:55:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:4194 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaHMGzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:55:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="575970032"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RESEND RFC 5/5] PCIe, AER: Update initial value of UC error mask
Date: Wed, 13 Aug 2014 02:22:41 -0400
Message-Id: <1407910961-7798-6-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PCI-e SPEC r3.0, BIT 0 of Uncorrectable Error Status Register
is redefined and it has an explicit requirement that when writing
this field, a value of 1b is the only choice. So change previous
initial maks from 0 to 1.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
NOTE: After scratching all use cases, this is the most obvious use
case to violate the SPEC. Most of use cases just read first and
then overwrite for clear purpose. Even so, such fix is obvious to
not compatiable with previous SPEC definition. Do we need a dirty
hack?

 arch/mips/pci/pci-octeon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 59cccd95688b..f1bfdc201297 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -134,7 +134,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 				       dconfig);
 		/* Enable reporting of all uncorrectable errors */
 		/* Uncorrectable Error Mask - turned on bits disable errors */
-		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 0);
+		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 1);
 		/*
 		 * Leave severity at HW default. This only controls if
 		 * errors are reported as uncorrectable or
-- 
2.0.0.rc2

