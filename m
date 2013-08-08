Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3HHNoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:44:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19427 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3HHNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:44:14 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-cc-5203a0ab4e4f
From: Tomasz Figa <t.figa@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 02/16] iommu/exynos: add missing cache flush for removed
 page table entries
Date: Thu, 08 Aug 2013 15:44:09 +0200
Message-id: <1726114.ptuhYydfjT@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <002601ce941a$e987ba50$bc972ef0$@samsung.com>
References: <002601ce941a$e987ba50$bc972ef0$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Vd3VC5iDDBony1vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MqY/WAha8FjroqdHV0sDYyvOboYOTkkBEwkPt08ygRh
	i0lcuLeerYuRi0NIYCmjxPG7G5khnC4mifYDbcwgVWwCahKfGx6xgdgiAhoSn6+sZwWxmQV+
	sEh82sYHYgsLpEh8vNfPDmKzCKhK7Nu7GMzmFdCUOLL0DwuIzS+gLvFu21OgzRwcogJuEhM+
	5oOEOQWsJG7+b2YFCQsJWEq8Oe4C0Sko8WPyPRaITfIS+/ZPhdqqJbF+53GmCYyCs5CUzUJS
	NgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIfH2ZQfj4mNWhxgFOBiVeHg7ApiC
	hFgTy4orcw8xSnAwK4nwvshiDhLiTUmsrEotyo8vKs1JLT7EyMTBKdXAaLwo0X1qVk3D1+s6
	Yr8YUtlmnAxKTny99bNGgx5b+0Wv9PiCj0Jul/6f/+LQI5/95AWT3zybH1yGy+cWbt3qdcGr
	PcZ6yZ03K/VvS+nuaXVYJjr1pPZ9aY9Duqnv9ZhfbYmvc5tr4hEQ9LhT/dOLYDUlue7DyR+X
	6nu0Ru1MbV90kGfTi+9cSizFGYmGWsxFxYkAtc+uIpUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of August 2013 18:37:34 Cho KyongHo wrote:
> This commit adds cache flush for removed small and large page entries
> in exynos_iommu_unmap(). Missing cache flush of removed page table
> entries can cause missing page fault interrupt when a master IP
> accesses an unmapped area.
> 
> Tested-by: Grant Grundler <grundler@chromium.org>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 233f382..d545a25 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct
> iommu_domain *domain, if (lv2ent_small(ent)) {
>  		*ent = 0;
>  		size = SPAGE_SIZE;
> +		pgtable_flush(ent, ent + 1);
>  		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
>  		goto done;
>  	}
> @@ -1010,6 +1011,7 @@ static size_t exynos_iommu_unmap(struct
> iommu_domain *domain, BUG_ON(size < LPAGE_SIZE);
> 
>  	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> +	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> 
>  	size = LPAGE_SIZE;
>  	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;

Looks reasonable.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

