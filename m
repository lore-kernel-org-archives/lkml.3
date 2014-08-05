Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbaHEK5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:57:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44589 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaHEKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-8c-53e0b6987267
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 09/29] ARM: dma-mapping: provide stubs if no ARM_DMA_USE_IOMMU
 has been selected
Date: Tue, 05 Aug 2014 12:47:37 +0200
Message-id: <1407235677-26324-10-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7oztj0INji3UM/i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAldHV+oqt4Dhvxb3Gr0wNjBu5uxg5OSQETCQm
	ff3ECGGLSVy4t56ti5GLQ0hgKaPE3IWPmCCcPiaJy7v+M4FUsQkYSnS97QKrEhHoZZTob/oB
	VsUssI5VYn/vdRaQKmGBJInub01gc1kEVCX2H17LDGLzCnhKPPtxigVin5zE/5crwKZyAsUP
	3zzACmILCXhI/Nywhn0CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx83UH49Jj
	VocYBTgYlXh4FfbeDRZiTSwrrsw9xCjBwawkwiux5kGwEG9KYmVValF+fFFpTmrxIUYmDk6p
	BsYN7tcmB6y0eXambe9/9QleURxcAo9Tlm/lehMV/fyzm2ua4GUlsXNpu39s7VuckHzsEvNC
	yWWiFt+kPNdc1/73fGvYt5OS9xo7Elr4HGweJcyp5j1fc8At7ce8benSgX+9/xQ4/nr1ONM+
	+piqlemttzPfX79R4NbS3/pohsmfT46rKuLXtK5QYinOSDTUYi4qTgQAM+KJbHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides stubs returing errors for all iommu related arm
dma-mapping functions, which are used when CONFIG_ARM_DMA_USE_IOMMU is
not set. This let drivers to use common code for iommu and non-iommu
cases without additional ifdefs.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/include/asm/dma-iommu.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/include/asm/dma-iommu.h b/arch/arm/include/asm/dma-iommu.h
index ae3dac0..1e57569 100644
--- a/arch/arm/include/asm/dma-iommu.h
+++ b/arch/arm/include/asm/dma-iommu.h
@@ -9,6 +9,8 @@
 #include <linux/kmemcheck.h>
 #include <linux/kref.h>
 
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
+
 struct dma_iommu_mapping {
 	/* iommu specific data */
 	struct iommu_domain	*domain;
@@ -38,5 +40,34 @@ int arm_iommu_create_default_mapping(struct device *dev, dma_addr_t base,
 
 void arm_iommu_release_default_mapping(struct device *dev);
 
+#else
+
+static inline struct dma_iommu_mapping *
+arm_iommu_create_mapping(struct bus_type *bus, dma_addr_t base, size_t size)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void
+arm_iommu_release_mapping(struct dma_iommu_mapping *mapping) { }
+
+static inline int arm_iommu_attach_device(struct device *dev,
+					struct dma_iommu_mapping *mapping)
+{
+	return -ENOSYS;
+}
+
+static inline void arm_iommu_detach_device(struct device *dev) { }
+
+static inline int arm_iommu_create_default_mapping(struct device *dev,
+						dma_addr_t base, size_t size)
+{
+	return -ENOSYS;
+}
+
+static inline void arm_iommu_release_default_mapping(struct device *dev) { }
+
+#endif
+
 #endif /* __KERNEL__ */
 #endif
-- 
1.9.2

