Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaHSMbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:31:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaHSMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:31:06 -0400
Message-ID: <53F34383.30100@suse.de>
Date: Tue, 19 Aug 2014 14:30:59 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
CC: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: Re: [PATCH 00/29] Exynos SYSMMU (IOMMU) integration with DT and DMA-mapping
 subsystem
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <20140818233201.GL9809@8bytes.org> <53F2E9AD.9030308@samsung.com> <53F3375E.6030402@suse.de> <53F33C9C.1080601@samsung.com>
In-Reply-To: <53F33C9C.1080601@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 19.08.2014 14:01, schrieb Marek Szyprowski:
> On 2014-08-19 13:39, Andreas Färber wrote:
>> I'm working on 5250 based Spring Chromebook and noticed that v3.17-rc1
>> got some more iommu support. With the new CONFIG_DRM_EXYNOS_IOMMU=y my
>> machine stops booting. So I'm wondering, is any of this a fix for 3.17,
>> or is all of this "unrelated" -next material?
> 
> This is probably a side effect of patch
> 3170447c1f264d51b8d1f3898bf2588588a64fdc
> ("iommu/exynos: Select ARM_DMA_USE_IOMMU"). It added selection of
> ARM_DMA_USE_IOMMU
> symbol, on which IOMMU support in Exynos DRM subsystem depends. However
> selecting
> this symbol is all that this patch does, without providing any code code
> which
> implements real support for ARM DMA IOMMU integration, which is needed
> by Exynos
> DRM driver. Please disable CONFIG_DRM_EXYNOS_IOMMU in kernel .config and
> your
> system should be bootable again.

Yes, that's what my report implied. :)

I'm bringing this up for -rc2 though: It sounds as if that option should
remain unavailable until the required code is in? Thanks.

>> Also, are you or someone
>> working on the respective DT changes for Exynos5?
> 
> I can prepare DT changes for Exynos5 as well, but first I wanted to
> clarify if
> everyone involved in generic IOMMU bindings and Exynos IOMMU driver
> agrees on my
> proposal.

Sure. I'm updating my old spring-bridge.v6 branch [1] to 3.17-rc1 [2],
which involves three drm bridge patches rebased onto the new drm panel
prepare/unprepare infrastructure plus two LVDS DT patches in addition to
the IOMMU patches. That old branch included DT changes for 5250 in "ARM:
dts: add System MMU nodes of Exynos SoCs", but that'll probably need
updating for the new bindings.

Regards,
Andreas

[1] https://github.com/afaerber/linux/commits/spring-bridge.v6
[2] https://github.com/afaerber/linux/commits/spring-next

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
