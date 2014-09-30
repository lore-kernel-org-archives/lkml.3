Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaI3LCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:02:10 -0400
Received: from 8bytes.org ([81.169.241.247]:58906 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaI3LCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:02:07 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, jroedel@suse.de
Subject: [PATCH 0/2] iommu/vt-d: Keep RMRR mappings around on driver unbind
Date: Tue, 30 Sep 2014 13:02:01 +0200
Message-Id: <1412074923-6342-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set to fix an issue recently discovered when
the Intel IOMMU is in use with devices that need RMRR
mappings.

The problem is that the RMRR mappings are destroyed when the
device driver is unbound from the device, causing DMAR
faults.

To solve this problem a device driver core change is
necessary to catch the right point in time for the IOMMU
code to destroy any mappings for a device.

With this patch-set the RMRR mappings are only destroyed
when the device is actually removed from the system.

Please review.

Thanks,

	Joerg

Joerg Roedel (2):
  driver core: Add BUS_NOTIFY_REMOVED_DEVICE event
  iommu/vt-d: Only remove domain when device is removed

 drivers/base/core.c         |  3 +++
 drivers/iommu/intel-iommu.c | 11 +----------
 include/linux/device.h      | 11 ++++++-----
 3 files changed, 10 insertions(+), 15 deletions(-)

-- 
1.9.1

