Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaHMG4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:56:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:11390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaHMGzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="584151634"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RESEND 4/5] PCIe, AER: Make AER UC status naming clearer
Date: Wed, 13 Aug 2014 02:22:40 -0400
Message-Id: <1407910961-7798-5-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PCI-e SPEC r3.0, BIT 0 of Uncorrectable Error Status Register
has been redefined for a different purpose.

BIT 0:
    Undefined – The value read from this bit is undefined. In
		previous versions of this specification, this
		bit was used to mask a Link Training Error.
		System software must ignore the value read from
		this bit. System software must only write a value
		of 1b to this bit.

Update related MACRO definition to reflect this change.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 include/ras/ras_event.h            | 2 +-
 include/uapi/linux/pci_regs.h      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index e50790e91f76..1de3f94aa7de 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -727,7 +727,7 @@ static int __init init_pci_ext_cap_err_perm(struct perm_bits *perm)
 	p_setd(perm, 0, ALL_VIRT, NO_WRITE);
 
 	/* Writable bits mask */
-	mask =	PCI_ERR_UNC_TRAIN |		/* Training */
+	mask =	PCI_ERR_UNC_UND |		/* Undefined */
 		PCI_ERR_UNC_DLP |		/* Data Link Protocol */
 		PCI_ERR_UNC_SURPDN |		/* Surprise Down */
 		PCI_ERR_UNC_POISON_TLP |	/* Poisoned TLP */
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 0f04a9755d1e..79abb9c71772 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -185,7 +185,7 @@ TRACE_EVENT(mc_event,
 	{PCI_ERR_COR_LOG_OVER,	"Header Log Overflow"}
 
 #define aer_uncorrectable_errors				\
-	{PCI_ERR_UNC_TRAIN,	"Undefined"},			\
+	{PCI_ERR_UNC_UND,	"Undefined"},			\
 	{PCI_ERR_UNC_DLP,	"Data Link Protocol Error"},	\
 	{PCI_ERR_UNC_SURPDN,	"Surprise Down Error"},		\
 	{PCI_ERR_UNC_POISON_TLP,"Poisoned TLP"},		\
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 30db069bce62..99e3182f2c96 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -630,7 +630,7 @@
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
-#define  PCI_ERR_UNC_TRAIN	0x00000001	/* Training */
+#define  PCI_ERR_UNC_UND	0x00000001	/* Undefined */
 #define  PCI_ERR_UNC_DLP	0x00000010	/* Data Link Protocol */
 #define  PCI_ERR_UNC_SURPDN	0x00000020	/* Surprise Down */
 #define  PCI_ERR_UNC_POISON_TLP	0x00001000	/* Poisoned TLP */
-- 
2.0.0.rc2

