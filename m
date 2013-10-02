Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3JBR6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:58:42 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:27193 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754740Ab3JBR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:58:39 -0400
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
Subject: [PATCH RFC 32/77] hpsa: Fallback to single MSI mode in case MSI-X failed
Date: Wed,  2 Oct 2013 12:48:48 +0200
Message-Id: <a8343fb00f8dfdcb637913b5a691dcea7ecffffc.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/hpsa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eb17b3d..252b65d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4112,7 +4112,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 
 		err = pci_msix_table_size(h->pdev);
 		if (err < ARRAY_SIZE(hpsa_msix_entries))
-			goto default_int_mode;
+			goto single_msi_mode;
 
 		for (i = 0; i < ARRAY_SIZE(hpsa_msix_entries); i++) {
 			hpsa_msix_entries[i].vector = 0;
@@ -4128,8 +4128,9 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			return;
 		}
 		dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
-		goto default_int_mode;
+		goto single_msi_mode;
 	}
+single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI\n");
 		if (!pci_enable_msi(h->pdev))
-- 
1.7.7.6

