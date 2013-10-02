Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3JBRpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:45:46 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26815 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755637Ab3JBRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:45:42 -0400
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
Subject: [PATCH RFC 17/77] cciss: Update a misleading comment on interrupt usage
Date: Wed,  2 Oct 2013 12:48:33 +0200
Message-Id: <3607cede809d07e1d1d6548a5f249d1ac2f9094c.1380703262.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 80068a0..bf11540 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4103,7 +4103,10 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 	}
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
-	/* if we get here we're going to use the default interrupt mode */
+	/*
+	 * If we get here we're going to use either the
+	 * default interrupt mode or single MSI mode
+	 */
 	h->intr[h->intr_mode] = h->pdev->irq;
 	return;
 }
-- 
1.7.7.6

