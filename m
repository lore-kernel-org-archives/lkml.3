Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3IINRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:17:48 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19209 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3IINRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:45 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 0/6] Simplify some mps and mrrs setting related code
Date: Mon, 9 Sep 2013 21:13:02 +0800
Message-ID: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series simplify mps and mrrs setting related code in drivers.
Export the pcie_set/get_mps() like pcie_set/get_readrq(). So drivers
can use these interfaces to simplify code that set mps and mrrs.
Patch 2 use pci_is_root_bus() instead of if (bus->parent) statement
for better readability.

Yijing Wang (6):
  PCI: Export pcie_set_mps() and pcie_get_mps()
  title/pci: use cached pci_dev->pcie_mpss to simplify code
  IB/qib: Use pci_is_root_bus() to check whether it is a root bus
  IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
  staging/et131x: Use cached pci_dev->pcie_mpss and pcie_set_readrq()
    to simplif code
  radeon: Use pcie_get_readrq() and pcie_set_readrq() to simplify code

 arch/tile/kernel/pci.c               |    7 +--
 drivers/gpu/drm/radeon/evergreen.c   |   19 ++-----
 drivers/infiniband/hw/qib/qib_pcie.c |   98 +++++++++++-----------------------
 drivers/pci/pci.c                    |    2 +
 drivers/staging/et131x/et131x.c      |   14 +----
 5 files changed, 44 insertions(+), 96 deletions(-)


