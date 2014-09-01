Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaIAFWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:22:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17205 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaIAFWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:22:38 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4a-5404029a6a5e
Message-id: <54040298.9020002@samsung.com>
Date: Mon, 01 Sep 2014 07:22:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-11-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1407235677-26324-11-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xq7qzmFhCDL6uNrD4O+kYu0Xz4vVs
	FpPuT2CxWLDf2qJz9gZ2i94FV9kszja9YbfonLiE3eLLlYdMFpseX2O1uLxrDpvFjPP7mCxO
	Xf/MZvGv9yCjxZnTl1gt/u/ZwW5x+E07q8WRh7vZLVbt+sNocfs3n4OIx5OD85g8fv+axOix
	c9Zddo/ZHTNZPTat6mTz2D93DbvH5iX1Hrf/PWb2mHxjOaPHlRNNrB69ze/YPLZcbWfx6Nuy
	itHj8ya5AL4oLpuU1JzMstQifbsErowLp76yFBznqnj8qo21gfESRxcjJ4eEgInEtdUb2SBs
	MYkL99YD2VwcQgJLGSV2XDkF5XxilLiy6gU7SBWvgJZE66OdjCA2i4CqxM55n8HibAKGEl1v
	u4AaODhEBaIkjn3NgygXlPgx+R4LyBwRgV5Gif6mH0wgCWaB/ywSO5/7gtjCAp4Ss57MZYdY
	1sEo0dzeyAKS4BTwkjixcC0jRIOZxJeXh1khbHmJzWveMk9gFJiFZMksJGWzkJQtYGRexSia
	WppcUJyUnmuoV5yYW1yal66XnJ+7iRESv192MC4+ZnWIUYCDUYmH98VC5hAh1sSy4srcQ4wS
	HMxKIrwvfwGFeFMSK6tSi/Lji0pzUosPMTJxcEo1MDLvk/thEed6vrh/VcJLts2G3r3m2Qu6
	dSZNuPh7mtKMGtvqrpRTx2+crCl4deLSxad8G5ymX9At3+CuF/z9746pe97ZZ/nG6+hK/vq2
	LdCYq319o6n9iWhJ75Rbk2K3vuNiPrb99VO9X8/Kl3S9M3b4ZmmXWFe0sWSHwC6V0MzGhVZr
	03f4FSmxFGckGmoxFxUnAgAMaxv3vQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 2014-08-05 12:47, Marek Szyprowski wrote:
> This patch adds a new flags for device drivers. This flag instructs
> kernel that the device driver does it own management of IOMMU assisted
> IO address space translations, so no default dma-mapping structures
> should be initialized.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   include/linux/device.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 5f4ff02..2e62371 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -253,6 +253,8 @@ struct device_driver {
>   
>   /* disables bind/unbind via sysfs */
>   #define DRIVER_SUPPRESS_BIND_ATTRS	(1 << 0)
> +/* driver uses own methods to manage IO address space */
> +#define DRIVER_HAS_OWN_IOMMU_MANAGER	(1 << 1)
>   
>   extern int __must_check driver_register(struct device_driver *drv);
>   extern void driver_unregister(struct device_driver *drv);

Could you comment if the approach of using flags in the struct driver
could be accepted? I've converted suppress_bind_attrs entry to flags to
avoid extending the structure, please see patch "[PATCH 05/29] drivers:
convert suppress_bind_attrs parameter into flags".

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

