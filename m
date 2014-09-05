Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaIEKxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:53:12 -0400
Received: from 8bytes.org ([81.169.241.247]:37759 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaIEKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:10 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 00/12] iommu: Convert iommu_domain_has_cap() to iommu_capable()
Date: Fri,  5 Sep 2014 12:52:52 +0200
Message-Id: <1409914384-21191-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set removes the iommu_domain_has_cap() function
from the IOMMU-API and replaces it with the new
iommu_capable() function.

The capabilities that can be queried with the
iommu_domain_has_cap() function are not domain specific, but
specific to the IOMMUs in the system, so they are not a
function of the domain. This should be reflected in the
IOMMU-API. Please review.

Thanks,

	Joerg

Joerg Roedel (12):
  iommu: Introduce iommu_capable API function
  iommu: Convert iommu-caps from define to enum
  iommu/amd: Convert to iommu_capable() API function
  iommu/arm-smmu: Convert to iommu_capable() API function
  iommu/fsl: Convert to iommu_capable() API function
  iommu/vt-d: Convert to iommu_capable() API function
  iommu/msm: Convert to iommu_capable() API function
  iommu/tegra: Convert to iommu_capable() API function
  kvm: iommu: Convert to use new iommu_capable() API function
  vfio: Convert to use new iommu_capable() API function
  IB/usnic: Convert to use new iommu_capable() API function
  iommu: Remove iommu_domain_has_cap() API function

 drivers/infiniband/hw/usnic/usnic_uiom.c |  2 +-
 drivers/iommu/amd_iommu.c                | 11 +++++-----
 drivers/iommu/arm-smmu.c                 | 35 ++++++++++++++++++++++++--------
 drivers/iommu/fsl_pamu_domain.c          |  5 ++---
 drivers/iommu/intel-iommu.c              | 13 +++++-------
 drivers/iommu/iommu.c                    | 19 ++++++++---------
 drivers/iommu/msm_iommu.c                |  7 +++----
 drivers/iommu/tegra-gart.c               |  7 +++----
 drivers/iommu/tegra-smmu.c               |  7 +++----
 drivers/vfio/vfio_iommu_type1.c          |  4 ++--
 include/linux/iommu.h                    | 25 +++++++++++------------
 virt/kvm/iommu.c                         |  6 ++----
 12 files changed, 73 insertions(+), 68 deletions(-)

-- 
1.9.1

