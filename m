Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3JBRoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:44:16 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26772 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754330Ab3JBRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:44:12 -0400
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
Subject: [PATCH RFC 36/77] ipr: Enable MSI-X when IPR_USE_MSIX type is set, not IPR_USE_MSI
Date: Wed,  2 Oct 2013 12:48:52 +0200
Message-Id: <2d4272136269f3cb3b1a5ac53b12aa45c7ea65c0.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fb57e21..762a93e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9527,7 +9527,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 		ipr_number_of_msix = IPR_MAX_MSIX_VECTORS;
 	}
 
-	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
+	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSIX &&
 			ipr_enable_msix(ioa_cfg) == 0)
 		ioa_cfg->intr_flag = IPR_USE_MSIX;
 	else if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
-- 
1.7.7.6

