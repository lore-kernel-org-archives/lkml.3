Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3KZV35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:29:57 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:53348 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752620Ab3KZV3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:29:55 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v3 02/11] PCI/MSI/s390: Remove superfluous check of MSI type
Date: Tue, 26 Nov 2013 10:09:51 +0100
Message-Id: <2e6f05522d2c7e477c4fa3071e0915f9999615ad.1385399393.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1385399393.git.agordeev@redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_setup_msi_irqs() hook can only be called from the generic
MSI code which ensures correct MSI type parameter.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/pci/pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index c79c6e4..61a3c2c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -425,8 +425,6 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	int rc;
 
 	pr_debug("%s: requesting %d MSI-X interrupts...", __func__, nvec);
-	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
-		return -EINVAL;
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);
-- 
1.7.7.6

