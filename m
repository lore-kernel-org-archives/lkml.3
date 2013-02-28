Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3B1AHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:07:10 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:7791 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3B1AHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:07:08 -0500
Message-ID: <1362010025.2808.35.camel@lorien2>
Subject: [PATCH v2 2/4] pci/aer: Remove local PCI_BUS() define and use
 PCI_BUS_NUM() from pci
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, bhelgaas@google.com
Cc: jiang.liu@huawei.com, shemminger@vyatta.com, paulmck@linux.vnet.ibm.com,
        linasvepstas@gmail.com, dhowells@redhat.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        wangyijing@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Wed, 27 Feb 2013 17:07:05 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to remove local PCI_BUS() define and use the new PCI_BUS_NUM()
interface from pci.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 564d97f..8ec8b4f 100644
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
@@ -106,7 +104,7 @@ static bool is_error_source(struct pci_dev *dev, struct aer_err_info *e_info)
 	 * When bus id is equal to 0, it might be a bad id
 	 * reported by root port.
 	 */
-	if (!nosourceid && (PCI_BUS(e_info->id) != 0)) {
+	if (!nosourceid && (PCI_BUS_NUM(e_info->id) != 0)) {
 		/* Device ID match? */
 		if (e_info->id == ((dev->bus->number << 8) | dev->devfn))
 			return true;
-- 
1.7.9.5



