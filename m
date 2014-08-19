Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaHSUSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:18:13 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:39760 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751284AbaHSUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:18:11 -0400
X-Greylist: delayed 2215 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2014 16:18:10 EDT
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] crypto: qat - Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Tue, 19 Aug 2014 09:32:04 +0200
Message-Id: <1408433524-11487-1-git-send-email-agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: qat-linux@intel.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index d4172de..1082e3b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -70,9 +70,9 @@ static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 	for (i = 0; i < msix_num_entries; i++)
 		pci_dev_info->msix_entries.entries[i].entry = i;
 
-	if (pci_enable_msix(pci_dev_info->pci_dev,
-			    pci_dev_info->msix_entries.entries,
-			    msix_num_entries)) {
+	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
+				  pci_dev_info->msix_entries.entries,
+				  msix_num_entries)) {
 		pr_err("QAT: Failed to enable MSIX IRQ\n");
 		return -EFAULT;
 	}
-- 
1.9.3

