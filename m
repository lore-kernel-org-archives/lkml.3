Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaHSGHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:07:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28476 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHSGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:07:45 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-26-53f2e9ae5539
Message-id: <53F2E9AD.9030308@samsung.com>
Date: Tue, 19 Aug 2014 08:07:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 00/29] Exynos SYSMMU (IOMMU) integration with DT and
 DMA-mapping subsystem
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <20140818233201.GL9809@8bytes.org>
In-reply-to: <20140818233201.GL9809@8bytes.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xK7rrXn4KNji5TN/i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7I4
	df0zm8W/3oOMFmdOX2K1+L9nB7vF4TftrBZHHu5mt1i16w+jxe3ffA4iHk8OzmPy+P1rEqPH
	zll32T1md8xk9di0qpPNY//cNewem5fUe9z+95jZY/KN5YweV040sXr0Nr9j89hytZ3Fo2/L
	KkaPz5vkAviiuGxSUnMyy1KL9O0SuDIOnzzMVnBdvGL/3i9MDYwf+LoYOTkkBEwkGp8+Z4Gw
	xSQu3FvP1sXIxSEksJRRoufDVUYI5xOjxJk3H9lAqngFtCTOLP7JCGKzCKhKNMx6wwRiswkY
	SnS97QKq4eAQFYiSOPY1D6JcUOLH5HtgC0QElCSuf25lBZnJLPCGVeL49HZ2kISwQILEvz8d
	YEVCArkSLyd/BtvFKaAvMX/HDLA4s4CZxJeXh1khbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRe
	xSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESvV92MC4+ZnWIUYCDUYmH98THj8FCrIllxZW5
	hxglOJiVRHgdX3wKFuJNSaysSi3Kjy8qzUktPsTIxMEp1cCYmDZhC0vmsV2SvBkrf0dxWNZr
	+l0QYnv15+bqEq790sX/VLVXXPlVzRb+4o20S/PTZKvnpxUf6rrXKmSpaCUedFthxrCfa1r+
	zX/Gz1JPcLee9SvhO1xr/ss6PvSAqNuqK5KWhyQlLjHGXky+y96//3TOao8Ld/hyk9V+LTjW
	fHc787TfT54qsRRnJBpqMRcVJwIAhr+MvLwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-19 01:32, Joerg Roedel wrote:
> On Tue, Aug 05, 2014 at 12:47:28PM +0200, Marek Szyprowski wrote:
>>   .../devicetree/bindings/iommu/samsung,sysmmu.txt   |  93 ++-
>>   Documentation/power/notifiers.txt                  |  14 +
>>   arch/arm/boot/dts/exynos4.dtsi                     | 118 ++++
>>   arch/arm/boot/dts/exynos4210.dtsi                  |  23 +
>>   arch/arm/boot/dts/exynos4x12.dtsi                  |  82 +++
>>   arch/arm/include/asm/dma-iommu.h                   |  36 ++
>>   arch/arm/mach-exynos/pm_domains.c                  |  12 +-
>>   arch/arm/mach-integrator/impd1.c                   |   2 +-
>>   arch/arm/mm/dma-mapping.c                          |  47 ++
>>   drivers/base/bus.c                                 |   4 +-
>>   drivers/base/dd.c                                  |  10 +-
>>   drivers/base/platform.c                            |   2 +-
>>   drivers/base/power/domain.c                        |  70 ++-
>>   drivers/clk/samsung/clk-exynos4.c                  |   1 +
>>   drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   1 +
>>   drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  26 +-
>>   drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   1 +
>>   drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   1 +
>>   drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   1 +
>>   drivers/gpu/drm/exynos/exynos_mixer.c              |   1 +
>>   drivers/iommu/exynos-iommu.c                       | 663 +++++++++++++--------
>>   drivers/iommu/iommu.c                              |   3 +
>>   drivers/media/platform/s5p-mfc/s5p_mfc.c           | 107 ++--
>>   drivers/pci/host/pci-mvebu.c                       |   2 +-
>>   drivers/pci/host/pci-rcar-gen2.c                   |   2 +-
>>   drivers/pci/host/pci-tegra.c                       |   2 +-
>>   drivers/pci/host/pcie-rcar.c                       |   2 +-
>>   drivers/soc/tegra/pmc.c                            |   2 +-
>>   include/dt-bindings/clock/exynos4.h                |  10 +-
>>   include/linux/device.h                             |  12 +-
>>   include/linux/iommu.h                              |   1 +
>>   include/linux/pm.h                                 |   2 +
>>   include/linux/pm_domain.h                          |  19 +
>>   33 files changed, 1016 insertions(+), 356 deletions(-)
> This touches a lot of non-iommu stuff. What is your strategy on getting
> this in, do you plan to get the non-iommu changes merged first or do you
> want to collect the respective Acks and merge this all through one tree?

Those patches are posted as one patchset mainly to demonstrate how to get
everything to work together. I also posted this as a single patch series
to get some feedback from other iommu developers, especially all those
involved in the generic iommu dt bindings.

For merging, I will split them into smaller series and try to get
respective acks.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

