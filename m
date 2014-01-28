Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaA1Ikj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbaA1Iht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 00/14] NVMe: Cleanup device initialization
Date: Tue, 28 Jan 2014 09:38:46 +0100
Message-Id: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith, Matthew,

Here are few fixes to the code that caught my eye.

These are unrelated to the patch "nvme: Use pci_enable_msi_range()
and pci_enable_msix_range()" I sent earlier, which still waits for
your review.

Thanks!

Alexander Gordeev (14):
  NVMe: Fix setup of affinity hint for unallocated queues
  NVMe: Cleanup nvme_alloc_queue() and nvme_free_queue()
  NVMe: Cleanup nvme_create_queue() and nvme_disable_queue()
  NVMe: Cleanup adapter_alloc_cq/sg() and adapter_delete_cq/sg()
  NVMe: Get rid of superfluous qid parameter to nvme_init_queue()
  NVMe: Get rid of superfluous dev parameter to queue_request_irq()
  NVMe: Make returning value consistent across all functions
  NVMe: nvme_dev_map() is a bad place to set admin queue IRQ number
  NVMe: Access interrupt vectors using nvme_queue::cq_vector only
  NVMe: Factor out nvme_set_queue_count()
  NVMe: Factor out nvme_init_bar()
  NVMe: Factor out nvme_init_interrupts()
  NVMe: Factor out nvme_setup_interrupts()
  NVMe: Rework "NVMe: Disable admin queue on init failure" commit

 drivers/block/nvme-core.c |  205 +++++++++++++++++++++++++++++----------------
 1 files changed, 133 insertions(+), 72 deletions(-)

-- 
1.7.7.6

