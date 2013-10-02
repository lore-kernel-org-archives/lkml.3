Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3JBSBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:01:45 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:27296 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753500Ab3JBSBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:01:43 -0400
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
Subject: [PATCH RFC 73/77] vmxnet3: Return -ENOSPC when not enough MSI-X vectors available
Date: Wed,  2 Oct 2013 12:49:29 +0200
Message-Id: <a24303b6fa85cfb01b4e1b6c67ff26825824d7f7.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3518173..3df7f32 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2752,7 +2752,10 @@ vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 				   "Failed to enable MSI-X, error: %d\n", err);
 			return err;
 		} else if (err < vector_threshold) {
-			break;
+			dev_info(&adapter->pdev->dev,
+				 "Number of MSI-Xs which can be allocated "
+				 "is lower than min threshold required.\n");
+			return -ENOSPC;
 		} else {
 			/* If fails to enable required number of MSI-x vectors
 			 * try enabling minimum number of vectors required.
@@ -2764,9 +2767,6 @@ vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 		}
 	}
 
-	dev_info(&adapter->pdev->dev,
-		 "Number of MSI-X interrupts which can be allocated "
-		 "is lower than min threshold required.\n");
 	return err;
 }
 
-- 
1.7.7.6

