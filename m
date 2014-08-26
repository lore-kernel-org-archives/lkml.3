Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbaHZJg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:36:28 -0400
Received: from 8bytes.org ([81.169.241.247]:55284 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbaHZJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:36:23 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/4] AMD IOMMU: Assign/de-assign complete alias groups
Date: Tue, 26 Aug 2014 11:36:10 +0200
Message-Id: <1409045774-32000-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch-set to fix the following issue:

When a device is added to an iommu domain, the current amd
iommu code will add the device itself and the device it
aliases to to the domain. But this alias relation is
uni-directional.

If, for example, device 03:00.1 aliases to 03:00.0 and is
added to a domain, the iommu code will add both devices.
But if 03.00.0 is added, 03.00.1 will be not.

This is a problem with some broken devices that appear with
function 0 on the bus but use function 1 as the request-id.
These devices will not work with the current implementation.

This patch-set changes the behavior of the code by
introducing alias-groups (similar to iommu-groups, but
support non-existent pci devices) and always
assigns/de-assigns complete alias groups to/from a domain.

This makes the alias relation bi-directional and fixes the
issues with broken devices.

Thanks,

	Joerg

Joerg Roedel (4):
  iommu/amd: Move struct iommu_dev_data to amd_iommu.c
  iommu/amd: Keep a list of devices in an alias group
  iommu/amd: Attach and detach complete alias group
  iommu/amd: Remove device binding reference count

 drivers/iommu/amd_iommu.c       | 74 +++++++++++++++++++++++++----------------
 drivers/iommu/amd_iommu_types.h | 21 ------------
 2 files changed, 46 insertions(+), 49 deletions(-)

-- 
1.9.1

