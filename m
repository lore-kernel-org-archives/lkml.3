Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3BKXAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:00:30 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48046 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759990Ab3BKXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:00:27 -0500
Message-ID: <1360623614.2950.60.camel@lorien2>
Subject: [PATCH 0/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to return
 bus number and device id
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, bhelgaas@google.com
Cc: jiang.liu@huawei.com, shemminger@vyatta.com, paulmck@linux.vnet.ibm.com,
        linasvepstas@gmail.com, dhowells@redhat.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        wangyijing@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Mon, 11 Feb 2013 16:00:14 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
it doesn't have interfaces to return PCI bus and PCI device id. Drivers
(AMD IOMMU, and AER) have module specific definitions for PCI_BUS() and
AMD_IOMMU driver also has a module specific interface to calculate PCI
device id from bus number and devfn.

This patch set adds PCI_BUS(), and PCI_DEVID() to pci.h, changes are to
use PCI_BUS() from pci. Changes AMD_IOMMU driver to use PCI_BUS() and
PCI_DEVID() from pci.

Files changed:

 include/uapi/linux/pci.h |    4 ++++
 1 file changed, 4 insertions(+)

 drivers/pci/pcie/aer/aerdrv_core.c |    2 --
 1 file changed, 2 deletions(-)

 drivers/iommu/amd_iommu_types.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

 drivers/iommu/amd_iommu.c       |    2 +-
 drivers/iommu/amd_iommu_init.c  |    6 +++---
 drivers/iommu/amd_iommu_types.h |    7 -------
 3 files changed, 4 insertions(+), 11 deletions(-)


