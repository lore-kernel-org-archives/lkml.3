Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3JBRuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:50:10 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26992 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755283Ab3JBRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:50:06 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 04/77] PCI/MSI/s390: Remove superfluous check of MSI type
Date: Wed,  2 Oct 2013 12:48:20 +0200
Message-Id: <bae65aa3e30dfd23bd5ed47add7310cfbb96243a.1380703262.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_setup_msi_irqs() hook can only be called from the generic
MSI code which ensures correct MSI type parameter.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
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

