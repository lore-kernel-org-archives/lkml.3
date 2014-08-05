Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbaHEK4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:56:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaHEKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:59 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-90-53e0b699a8da
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
Subject: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
Date: Tue, 05 Aug 2014 12:47:38 +0200
Message-id: <1407235677-26324-11-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7oztz0INliyTM3i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlXH4VxtrQQ97xapVt1kaGH+wdjFyckgImEg8
	ePaLDcIWk7hwbz2QzcUhJLCUUeLL815mCKePSWLvlN9MIFVsAoYSXW+7wKpEBHoZJfqbfjCB
	OMwC61gl9vdeZwGpEhZwldh3bQfYDhYBVYmZn3+CxXkFPCVW/5kJtVtO4v/LFWBTOYHih28e
	AIsLCXhI/Nywhn0CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx83UH49JjVocY
	BTgYlXh4FfbeDRZiTSwrrsw9xCjBwawkwiux5kGwEG9KYmVValF+fFFpTmrxIUYmDk6pBkar
	+QKzmXvf2Syd5VK0zbBDaJFApsTrF5vWi0v1N3FVNBfolWtPY2J8ffNxH5voyatb922SniC2
	8lzFm79ZwjWcP3z+arOlfhTmYeA8w7rHVejr7eRVE2pZM1dFdkXnFfx/8WjK1Zowm4nRz+rV
	rq84ZCydJfhh8Y5jbKG3uEL3ecw0vswv567EUpyRaKjFXFScCABCxS9NewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new flags for device drivers. This flag instructs
kernel that the device driver does it own management of IOMMU assisted
IO address space translations, so no default dma-mapping structures
should be initialized.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/device.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 5f4ff02..2e62371 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -253,6 +253,8 @@ struct device_driver {
 
 /* disables bind/unbind via sysfs */
 #define DRIVER_SUPPRESS_BIND_ATTRS	(1 << 0)
+/* driver uses own methods to manage IO address space */
+#define DRIVER_HAS_OWN_IOMMU_MANAGER	(1 << 1)
 
 extern int __must_check driver_register(struct device_driver *drv);
 extern void driver_unregister(struct device_driver *drv);
-- 
1.9.2

