Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaBZJCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:02:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBZJCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:02:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 0/2] block: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Wed, 26 Feb 2014 10:02:40 +0100
Message-Id: <cover.1393404496.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
  - cciss: patch #1: a weird 'goto' removed;
  - cciss: patch #2: pci_enable_msix_exact() used, not pci_enable_msix_range();
  - rsxx: patch dropped - no need to change anything;

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

This change updates 'cciss' only, but there is also 'nvme' update
pending - I am waiting for Intel guys to clarify if they want to
route it thru their tree. If not, I will post the 'nvme' patch as
a follow-up to this series.

Thanks!

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (2):
  cciss: Fallback to MSI rather than to INTx if MSI-X failed
  cciss: Use pci_enable_msix_exact() instead of pci_enable_msix()

 drivers/block/cciss.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

-- 
1.7.7.6

