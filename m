Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaBSI4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaBSI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:37 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Miller <mike.miller@hp.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: [PATCH 0/9] block: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 09:58:12 +0100
Message-Id: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Joshua Morris <josh.h.morris@us.ibm.com>
Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: iss_storagedev@hp.com
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (9):
  cciss: Fallback to MSI rather than to INTx if MSI-X failed
  cciss: Use pci_enable_msix_range() instead of pci_enable_msix()
  mtip32xx: Remove superfluous call to pci_disable_msi()
  mtip32xx: Use pci_enable_msix_range() instead of pci_enable_msix()
  rsxx: Use pci_enable_msix_range() instead of pci_enable_msix()
  skd: Fix out of array boundary access
  skd: Fix incomplete cleanup of MSI-X interrupt
  skd: Use unified access to skdev->msix_entries throughout the code
  skd: Use pci_enable_msix_range() instead of pci_enable_msix()

 drivers/block/cciss.c             |   14 +++-----
 drivers/block/mtip32xx/mtip32xx.c |    8 +++--
 drivers/block/rsxx/core.c         |    4 +-
 drivers/block/skd_main.c          |   67 +++++++++++++++----------------------
 4 files changed, 39 insertions(+), 54 deletions(-)

-- 
1.7.7.6

