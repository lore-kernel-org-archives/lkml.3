Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3HIECR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:02:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52373 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3HIECN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:02:13 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-36-520469c3d0bb
Date: Fri, 09 Aug 2013 13:02:10 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
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
Message-id: <20130809130210.e234ea77131fe15ab3f8abb1@samsung.com>
In-reply-to: <1726114.ptuhYydfjT@amdc1227>
References: <002601ce941a$e987ba50$bc972ef0$@samsung.com>
 <1726114.ptuhYydfjT@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zQ93DmSxBBm/XCFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVx6fMmloImnooPJ7oYGxjPc3YxcnJICJhInG0/yAZh
	i0lcuLceyObiEBJYxijR03mLGaaoZ9dzVojEdEaJBSfWMUI4k5gkFs74wQpSxSKgKnHn71kW
	EJtNQEti9dzjjCC2iICKxOVT08FsZoEfLBKftvGB2MICKRIf7/Wzg9i8Ao4S7yb9A9vGCdTb
	+3M/2ElCApESB3c/ZYe4wkLiQlMHVL2gxI/J91ggZmpJbN7WxAphy0tsXvOWGeQ4CYG5HBLd
	l5uhjhOQ+Db5EFADB1BCVmLTAajPJCUOrrjBMoFRbBaSsbOQjJ2FZOwCRuZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGCHRPmEH470D1ocYk4FWTmSWEk3OByaLvJJ4Q2MzIwtTE1NjI3NL
	M9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwst16vnb2ZKlZ9rfuFC5UODWn
	/DBb6qG3EhWbV4vk6j6913DyPNAhr6snBG866bNKej+LetSZFb0Ze+Yzvk1O72XmDbHRfSdS
	9Y1NbbWcfumdDRcXeuywXxZ6xLVDy/1rINehT4E6/uGzyx7ZLbGoFDPfoqi68fWFskVJe44f
	bP7xNuvegcbXSizFGYmGWsxFxYkAuAojhQwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd3DmSxBBrO28VrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49LnTSwFTTwV
	H050MTYwnufsYuTkkBAwkejZ9ZwVwhaTuHBvPVsXIxeHkMB0RokFJ9YxQjiTmCQWzvgBVsUi
	oCpx5+9ZFhCbTUBLYvXc44wgtoiAisTlU9PBbGaBHywSn7bxgdjCAikSH+/1s4PYvAKOEu8m
	/WMGsTmBent/7mcDsYUEIiUO7n7KDnGFhcSFpg6oekGJH5PvsUDM1JLYvK2JFcKWl9i85i3z
	BEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4FTyTHoH46oGi0OM
	AhyMSjy8ituZg4RYE8uKK3MPMUpwMCuJ8L7IAgrxpiRWVqUW5ccXleakFh9iTAaGxkRmKdHk
	fGCayyuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxroJrw8b
	Xjq9qrFBc5miftvLGbP2rn8VvM71w6Inp9bZzePJCZd4Jnp2gu4k6eeqx7UUjGu138rU1zMc
	EDlYIaT5VVKxLfHhxt1pPWfaNx/l2H5//ffdT5azXV5bVpei/zB5kcJ7192mP/9GeE3vjHlb
	xvIzXbfbuEF/2+RDFXy8plurah0D9JVYijMSDbWYi4oTAVrPe4NpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 15:44:09 +0200, Tomasz Figa wrote:
> On Thursday 08 of August 2013 18:37:34 Cho KyongHo wrote:
> > This commit adds cache flush for removed small and large page entries
> > in exynos_iommu_unmap(). Missing cache flush of removed page table
> > entries can cause missing page fault interrupt when a master IP
> > accesses an unmapped area.
> > 
> > Tested-by: Grant Grundler <grundler@chromium.org>
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 233f382..d545a25 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct
> > iommu_domain *domain, if (lv2ent_small(ent)) {
> >  		*ent = 0;
> >  		size = SPAGE_SIZE;
> > +		pgtable_flush(ent, ent + 1);
> >  		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
> >  		goto done;
> >  	}
> > @@ -1010,6 +1011,7 @@ static size_t exynos_iommu_unmap(struct
> > iommu_domain *domain, BUG_ON(size < LPAGE_SIZE);
> > 
> >  	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> > +	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> > 
> >  	size = LPAGE_SIZE;
> >  	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
> 
> Looks reasonable.
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 

Thanks.

KyongHo.
> Best regards,
> Tomasz
> 
