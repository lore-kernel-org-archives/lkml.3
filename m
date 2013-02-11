Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3BKXBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:01:02 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14677 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab3BKXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:01:00 -0500
Message-ID: <1360623655.2950.66.camel@lorien2>
Subject: [PATCH 2/4] pci/aer: Remove local PCI_BUS() define and use
 PCI_BUS() from pci
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, bhelgaas@google.com
Cc: dhowells@redhat.com, davej@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        shemminger@vyatta.com, jiang.liu@huawei.com, linasvepstas@gmail.com,
        paulmck@linux.vnet.ibm.com, wangyijing@huawei.com, shuahkhan@gmail.com
Date: Mon, 11 Feb 2013 16:00:55 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to remove local PCI_BUS() define and use the new PCI_BUS interface from
pci.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 564d97f..69e406e 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -89,8 +89,6 @@ static int add_error_device(struct aer_err_info *e_info, struct pci_dev *dev)
 	return -ENOSPC;
 }
 
-#define	PCI_BUS(x)	(((x) >> 8) & 0xff)
-
 /**
  * is_error_source - check whether the device is source of reported error
  * @dev: pointer to pci_dev to be checked
-- 
1.7.9.5



