Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3FFSP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:15:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4099 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3FFSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:15:56 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com, gong.chen@linux.intel.com,
        greg.pearson@hp.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v2 4/6] PCI/ACPI: Move AER severity defines to aer.h
Date: Thu,  6 Jun 2013 12:10:49 -0600
Message-Id: <1370542251-27387-5-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function aer_recover_queue() is a public interface and the
severity argument uses #defines that are in the private header
pci/pcie/aer/aerdrv.h.

This patch moves the #defines from pci/pcie/aer/aerdrv.h to 
include/linux/aer.h.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv.h |    4 ----
 include/linux/aer.h           |   16 ++++++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index d12c77c..90ea3e8 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -13,10 +13,6 @@
 #include <linux/aer.h>
 #include <linux/interrupt.h>
 
-#define AER_NONFATAL			0
-#define AER_FATAL			1
-#define AER_CORRECTABLE			2
-
 #define SYSTEM_ERROR_INTR_ON_MESG_MASK	(PCI_EXP_RTCTL_SECEE|	\
 					PCI_EXP_RTCTL_SENFEE|	\
 					PCI_EXP_RTCTL_SEFEE)
diff --git a/include/linux/aer.h b/include/linux/aer.h
index ec10e1b..0f6a9e2 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -7,6 +7,10 @@
 #ifndef _AER_H_
 #define _AER_H_
 
+#define AER_NONFATAL			0
+#define AER_FATAL			1
+#define AER_CORRECTABLE			2
+
 struct aer_header_log_regs {
 	unsigned int dw0;
 	unsigned int dw1;
@@ -31,9 +35,9 @@ struct aer_capability_regs {
 
 #if defined(CONFIG_PCIEAER)
 /* pci-e port driver needs this function to enable aer */
-extern int pci_enable_pcie_error_reporting(struct pci_dev *dev);
-extern int pci_disable_pcie_error_reporting(struct pci_dev *dev);
-extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
+int pci_enable_pcie_error_reporting(struct pci_dev *dev);
+int pci_disable_pcie_error_reporting(struct pci_dev *dev);
+int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
 #else
 static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
@@ -49,10 +53,10 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 }
 #endif
 
-extern void cper_print_aer(const char *prefix, struct pci_dev *dev,
+void cper_print_aer(const char *prefix, struct pci_dev *dev,
 			   int cper_severity, struct aer_capability_regs *aer);
-extern int cper_severity_to_aer(int cper_severity);
-extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
+int cper_severity_to_aer(int cper_severity);
+void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 			      int severity);
 #endif //_AER_H_
 
