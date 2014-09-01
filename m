Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaIAHxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:53:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25591 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaIAHxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:53:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-29-540425fb949d
Message-id: <540425F9.7080307@samsung.com>
Date: Mon, 01 Sep 2014 09:53:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Thierry Reding <treding@nvidia.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-11-git-send-email-m.szyprowski@samsung.com>
 <54040298.9020002@samsung.com> <20140901070748.GA24226@ulmo.nvidia.com>
In-reply-to: <20140901070748.GA24226@ulmo.nvidia.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xy7q/VVlCDK7M0LH4O+kYu0Xz4vVs
	FpPuT2CxWLDf2qJz9gZ2i94FV9kszja9YbfonLiE3eLLlYdMFpseX2O1uLxrDpvFjPP7mCxO
	Xf/MZvGv9yCjxZnTl1gt/u/ZwW5x+E07q8WRh7vZLVbt+sNocfs3n4OIx5OD85g8fv+axOix
	c9Zddo/ZHTNZPTat6mTz2D93DbvH5iX1Hrf/PWb2mHxjOaPHlRNNrB69ze/YPLZcbWfx6Nuy
	itHj8ya5AL4oLpuU1JzMstQifbsEroz9j9ewF0wWrWh418XUwDhVsIuRk0NCwESicdknRghb
	TOLCvfVsXYxcHEICSxklzq16wgzhfGKUuPlsHwtIFa+AlsS6bw2sIDaLgKrErO57bCA2m4Ch
	RNfbLiCbg0NUIEri2Nc8iHJBiR+T74G1igioS0x4uZYFZCazwGJ2iZmf34NtFhbwlJj1ZC47
	xLJLjBKdL3uZQBKcAqYS25tngHUzC5hJfHl5mBXClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZV
	jKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHx+2UH4+JjVocYBTgYlXh4XyxkDhFiTSwrrsw9
	xCjBwawkwjtPmCVEiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Nge4OUoZazzO8rTcsPrllbFq8S
	NqHuDv+S2hdOwVqVIjELiibEMDfvUsrePrvD7Hdms224/B8Nxl9MbtklCet1RM2XJ7787Zv8
	dEtj3d9Nqs9/bvJ2P9IjP+cN2xzFvVNCE1Njzj1Njox4XlH46MCPfI4Nhe2bmMLfz3uzpO7B
	txKdbY6pdkosxRmJhlrMRcWJAHaykeK9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-09-01 09:07, Thierry Reding wrote:
> On Mon, Sep 01, 2014 at 07:22:32AM +0200, Marek Szyprowski wrote:
>> Hi Greg,
>>
>> On 2014-08-05 12:47, Marek Szyprowski wrote:
>>> This patch adds a new flags for device drivers. This flag instructs
>>> kernel that the device driver does it own management of IOMMU assisted
>>> IO address space translations, so no default dma-mapping structures
>>> should be initialized.
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> ---
>>>    include/linux/device.h | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/linux/device.h b/include/linux/device.h
>>> index 5f4ff02..2e62371 100644
>>> --- a/include/linux/device.h
>>> +++ b/include/linux/device.h
>>> @@ -253,6 +253,8 @@ struct device_driver {
>>>    
>>>    /* disables bind/unbind via sysfs */
>>>    #define DRIVER_SUPPRESS_BIND_ATTRS	(1 << 0)
>>> +/* driver uses own methods to manage IO address space */
>>> +#define DRIVER_HAS_OWN_IOMMU_MANAGER	(1 << 1)
>>>    
>>>    extern int __must_check driver_register(struct device_driver *drv);
>>>    extern void driver_unregister(struct device_driver *drv);
>> Could you comment if the approach of using flags in the struct driver
>> could be accepted? I've converted suppress_bind_attrs entry to flags to
>> avoid extending the structure, please see patch "[PATCH 05/29] drivers:
>> convert suppress_bind_attrs parameter into flags".
> Is this really necessary? What I did as part of an RFC series for Tegra
> IOMMU support is keep this knowledge within the IOMMU driver rather than
> export it to the driver core.i

The problem with embedding the list of drivers that you would need to update
it everytime when you modify or extend iommu support in the other drivers.
I've tried also other approach, like adding respective notifiers to 
individual
drivers to initialize custom iommu support (or disable default iommu 
mapping)
before iommu driver gets initialized, but such solution is in my opinion too
complex and hard to understand if one is not familiar will all this stuff.

All in all it turned out that the simplest and most generic way is to simply
add the flag to the driver core. Flags might be also used in the future
to model other kinds of dependencies between device drivers and/or driver
core.

> The idea being that the IOMMU driver wouldn't create an ARM DMA/IOMMU
> mapping by default but rather allow individual drivers to be marked as
> "kernel-internal" and use the DMA/IOMMU glue in that case. Drivers such
> as DRM would use the IOMMU API directly.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

