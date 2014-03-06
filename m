Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaCFUJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:09:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaCFUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:09:32 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 0/4] : Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Thu,  6 Mar 2014 21:11:20 +0100
Message-Id: <cover.1394128952.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series is based on 3.14-rc4.

The patches are unrelated to each other.

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Alexander Gordeev (4):
  ioat: Use pci_enable_msix_exact() instead of pci_enable_msix()
  portdrv: Use pci_enable_msix_exact() instead of pci_enable_msix()
  tsi721: Use pci_enable_msix_exact() instead of pci_enable_msix()
  xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()

 drivers/dma/ioat/dma.c           |    2 +-
 drivers/pci/pcie/portdrv_core.c  |    4 ++--
 drivers/rapidio/devices/tsi721.c |   11 +++--------
 drivers/usb/host/xhci.c          |    7 ++++---
 4 files changed, 10 insertions(+), 14 deletions(-)

-- 
1.7.7.6

