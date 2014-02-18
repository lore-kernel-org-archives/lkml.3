Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaBRPHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:07:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbaBRPHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:07:11 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 0/2] ib: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 16:09:00 +0100
Message-Id: <cover.1392733151.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (2):
  mthca: Use pci_enable_msix_range() instead of pci_enable_msix()
  qib: Use pci_enable_msix_range() instead of pci_enable_msix()

 drivers/infiniband/hw/mthca/mthca_main.c |    9 ++---
 drivers/infiniband/hw/qib/qib_pcie.c     |   55 +++++++++++++++--------------
 2 files changed, 31 insertions(+), 33 deletions(-)

-- 
1.7.7.6

