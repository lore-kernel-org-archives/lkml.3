Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3JBR6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:58:47 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:27197 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755602Ab3JBR6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:58:43 -0400
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
Subject: [PATCH RFC 76/77] vxge: Sanitize MSI-X allocation routine error codes
Date: Wed,  2 Oct 2013 12:49:32 +0200
Message-Id: <20ecd1136cc5bd932c1bb4a2d89dae1ca0d900dd.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 5a20eaf..b81ff8b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2352,7 +2352,7 @@ start:
 			"%s: MSI-X enable failed for %d vectors, ret: %d",
 			VXGE_DRIVER_NAME, vdev->intr_cnt, ret);
 		if ((max_config_vpath != VXGE_USE_DEFAULT) || (ret < 3)) {
-			ret = -ENODEV;
+			ret = -ENOSPC;
 			goto enable_msix_failed;
 		}
 
@@ -2365,10 +2365,8 @@ start:
 		vxge_close_vpaths(vdev, temp);
 		vdev->no_of_vpath = temp;
 		goto start;
-	} else if (ret < 0) {
-		ret = -ENODEV;
+	} else if (ret < 0)
 		goto enable_msix_failed;
-	}
 	return 0;
 
 enable_msix_failed:
-- 
1.7.7.6

