Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbbAZXvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:51:53 -0500
Received: from 8bytes.org ([81.169.241.247]:50748 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835AbbAZXvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:48 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-tegra@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        jroedel@suse.de
Subject: [PATCH 00/15] iommu: Move domain allocation into drivers
Date: Tue, 27 Jan 2015 00:51:30 +0100
Message-Id: <1422316305-19216-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is patch-set to replace the existing domain_init and
domain_destroy iommu-ops with the new domain_alloc and
domain_free callbacks

The new callbacks move the allocation of iommu domains into
the iommu driver, allowing them to put a generic
iommu_domain struct into their own domain struct. This makes
domain handling in the drivers more cache efficient and
prepares the introduction of default domains in another
patch-set.

While at it, this patch-set also introduces domain types.
These are internal to the iommu core code for now, there are
three of them:

	* DMA-API domains
	* Identity mapped domains
	* Domains unmanaged by the iommu-core, used for
	  iommu-api so that the users can create their own
	  mappings

The patches have been compile tested for x86, ARM and PPC
and runtime tested on x86 (Intel VT-d and AMD IOMMU).

Please review.

Thanks,

	Joerg

Joerg Roedel (15):
  iommu: Introduce domain_alloc and domain_free iommu_ops
  iommu: Introduce iommu domain types
  iommu/amd: Make use of domain_alloc and domain_free
  iommu/vt-d: Make use of domain_alloc and domain_free
  iommu/omap: Make use of domain_alloc and domain_free
  iommu/arm-smmu: Make use of domain_alloc and domain_free
  iommu/exynos: Make use of domain_alloc and domain_free
  iommu/tegra-smmu: Make use of domain_alloc and domain_free
  iommu/tegra-gart: Make use of domain_alloc and domain_free
  iommu/msm: Make use of domain_alloc and domain_free
  iommu/shmobile: Make use of domain_alloc and domain_free
  iommu/ipmmu-vmsa: Make use of domain_alloc and domain_free
  iommu/rockchip: Make use of domain_alloc and domain_free
  iommu/fsl: Make use of domain_alloc and domain_free
  iommu: Remove domain_init and domain_free iommu_ops

 drivers/iommu/amd_iommu.c       | 84 +++++++++++++++++++++------------------
 drivers/iommu/amd_iommu_types.h |  7 ++--
 drivers/iommu/arm-smmu.c        | 46 +++++++++++++---------
 drivers/iommu/exynos-iommu.c    | 87 ++++++++++++++++++++++-------------------
 drivers/iommu/fsl_pamu_domain.c | 60 +++++++++++++++-------------
 drivers/iommu/fsl_pamu_domain.h |  2 +-
 drivers/iommu/intel-iommu.c     | 48 +++++++++++++----------
 drivers/iommu/iommu.c           | 20 ++--------
 drivers/iommu/ipmmu-vmsa.c      | 43 +++++++++++---------
 drivers/iommu/msm_iommu.c       | 73 +++++++++++++++++-----------------
 drivers/iommu/omap-iommu.c      | 49 +++++++++++++----------
 drivers/iommu/rockchip-iommu.c  | 40 +++++++++++--------
 drivers/iommu/shmobile-iommu.c  | 40 +++++++++++--------
 drivers/iommu/tegra-gart.c      | 67 +++++++++++++++++++++----------
 drivers/iommu/tegra-smmu.c      | 41 ++++++++++---------
 include/linux/iommu.h           | 17 ++++++--
 16 files changed, 407 insertions(+), 317 deletions(-)

-- 
1.8.4.5

