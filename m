Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJBKJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:09:20 -0400
Received: from 8bytes.org ([81.169.241.247]:45150 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaJBKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:09:16 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, jroedel@suse.de,
        joro@8bytes.org
Subject: [PATCH 0/2] iommu/vt-d: Make RMRR matching compatible with older kernels
Date: Thu,  2 Oct 2014 12:09:06 +0200
Message-Id: <1412244548-27617-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set to make RMRR matching in the Intel IOMMU
driver compatible with older kernels. This is needed because
some BIOS vendors build RMRR entries to work with older
kernels, but that will break on newer ones that implement
the correct PCI device scope matching scheme defined in the
VT-d specification.

Make the current Intel IOMMU driver work with the old RMRR
entries too.

These patches have been tested in an affected system and fix
the issue seen there (newer kernel did not setup RMRR
entries for a plugged in device).

Regards,

	Joerg

Joerg Roedel (2):
  iommu/vt-d: Store bus information in RMRR PCI device path
  iommu/vt-d: Work around broken RMRR firmware entries

 drivers/iommu/dmar.c | 23 ++++++++++++++++++++---
 include/linux/dmar.h |  8 +++++++-
 2 files changed, 27 insertions(+), 4 deletions(-)

-- 
1.9.1

