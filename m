Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967254Ab3HIF6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:58:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13595 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966964Ab3HIF6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:58:51 -0400
X-AuditID: cbfee68e-b7f276d000002279-17-52048519ec8a
Date: Fri, 09 Aug 2013 14:58:49 +0900
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
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own
 slab
Message-id: <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
In-reply-to: <2544843.sndV7usHTj@amdc1227>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
 <2544843.sndV7usHTj@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zfV3JVpYgg6+njCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jN4sDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mp4OWkhW8Fx2YrmB72sDYxrxLsYOTkkBEwkjs/6yQph
	i0lcuLeerYuRi0NIYBmjxJXp9xhhih5enMIEkZjOKHHzwhxGCGcSk8SaaYfZQapYBFQlNt7e
	yARiswloSayeexysW0RAReLyqelgNrPADxaJT9v4QGxhgWCJTc9+AsU5OHgFHCVOPQ8BCXMC
	tT47eADsIiGBSInpL+axQBxhIXGhqQNsFa+AoMSPyfdYIEZqSWze1sQKYctLbF7zlhnkNgmB
	hRwSj9dvZYO4TUDi2+RDLCC7JARkJTYdYIaYKSlxcMUNlgmMYrOQjJ2FZOwsJGMXMDKvYhRN
	LUguKE5KLzLSK07MLS7NS9dLzs/dxAiJ9b4djDcPWB9iTAZaOZFZSjQ5H5gq8kriDY3NjCxM
	TUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKDmzOd3S9M/bHRNE
	xdYwMp5yMo9dJfn1pfLshkmep81sKg1XvFykucAwxL3l1PI5jr7f994RM1av3Stw93XN3Zzf
	B+vZPml4FmaFB2mlqq29fDexfGE2q9PERUr3/cXZlu7YceCWnsHT1ZKHbnv91zf7ynyuenLv
	/D/zpohk77O5z7N+j8pfVyWW4oxEQy3mouJEAA1Sq/gLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQV3JVpYgg9+HdCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jN4sDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8XLSQraC47IV
	zQ96WRsY14h3MXJySAiYSDy8OIUJwhaTuHBvPVsXIxeHkMB0RombF+YwQjiTmCTWTDvMDlLF
	IqAqsfH2RrAONgEtidVzjzOC2CICKhKXT00Hs5kFfrBIfNrGB2ILCwRLbHr2EyjOwcEr4Chx
	6nkISJgTqPXZwQOsILaQQKTE9BfzWCCOsJC40NQBtopXQFDix+R7LBAjtSQ2b2tihbDlJTav
	ecs8gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJE8k9rBuLLB
	4hCjAAejEg+v4nbmICHWxLLiytxDjBIczEoivC+ygEK8KYmVValF+fFFpTmpxYcYk4GBMZFZ
	SjQ5H5jk8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsU2B
	b/dyEVMv3qDPsc6Lw1/kVYjN4fUK37ZzVYPXPo4PjJuft86s+vHfbiKTwsWIxLDCH4dt31z2
	sthqpSfTHTjjRk/nMd47B8KPmdqziumkRHh52pZnRW7X8rwWvUfSKkCYb7bxR4l/WxqZDjb9
	uRt6iT1K3vnBlbDKS+Zect/iT976ssBciaU4I9FQi7moOBEAiiwtgWgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 16:00:18 +0200, Tomasz Figa wrote:
> On Thursday 08 of August 2013 18:38:04 Cho KyongHo wrote:
> > Since kmalloc() does not guarantee that the allignment of 1KiB when it
> > allocates 1KiB, it is required to allocate lv2 page table from own
> > slab that guarantees alignment of 1KiB
> > 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
> >  1 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index d90e6fa..a318049 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -100,6 +100,8 @@
> >  #define REG_PB1_SADDR		0x054
> >  #define REG_PB1_EADDR		0x058
> > 
> > +static struct kmem_cache *lv2table_kmem_cache;
> > +
> >  static unsigned long *section_entry(unsigned long *pgtable, unsigned
> > long iova) {
> >  	return pgtable + lv1ent_offset(iova);
> > @@ -765,7 +767,8 @@ static void exynos_iommu_domain_destroy(struct
> > iommu_domain *domain)
> > 
> >  	for (i = 0; i < NUM_LV1ENTRIES; i++)
> >  		if (lv1ent_page(priv->pgtable + i))
> > -			kfree(__va(lv2table_base(priv->pgtable + i)));
> > +			kmem_cache_free(lv2table_kmem_cache,
> > +					__va(lv2table_base(priv->pgtable + i)));
> > 
> >  	free_pages((unsigned long)priv->pgtable, 2);
> >  	free_pages((unsigned long)priv->lv2entcnt, 1);
> > @@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned long
> > *sent, unsigned long iova, if (lv1ent_fault(sent)) {
> >  		unsigned long *pent;
> > 
> > -		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> > +		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
> >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> >  		if (!pent)
> >  			return ERR_PTR(-ENOMEM);
> > @@ -881,7 +884,7 @@ static int lv1set_section(unsigned long *sent,
> > phys_addr_t paddr, short *pgcnt)
> > 
> >  	if (lv1ent_page(sent)) {
> >  		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> > -		kfree(page_entry(sent, 0));
> > +		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
> >  		*pgcnt = 0;
> >  	}
> > 
> > @@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
> >  {
> >  	int ret;
> > 
> > +	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > +				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > +	if (!lv2table_kmem_cache) {
> > +		pr_err("%s: Failed to create kmem cache\n", __func__);
> > +		return -ENOMEM;
> > +	}
> > +
> >  	ret = platform_driver_register(&exynos_sysmmu_driver);
> > 
> >  	if (ret == 0)
> > -		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > +		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > +
> > +	if (ret) {
> > +		pr_err("%s: Failed to register exynos-iommu driver.\n",
> > +								__func__);
> > +		kmem_cache_destroy(lv2table_kmem_cache);
> > +	}
> 
> What about making the return value handling here cleaner? For example:
> 
> 	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> 				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> 	if (!lv2table_kmem_cache) {
> 		...
> 		return -ENOMEM;
> 	}
> 
> 	ret = platform_driver_register(&exynos_sysmmu_driver);
> 	if (ret) {
> 		...
> 		goto err_destroy_kmem_cache;
> 	}
> 
> 	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> 	if (ret) {
> 		...
> 		goto err_platform_unregister;
> 	}
> 
> 	return 0;
> 
> err_platform_unregister:
> 	...
> err_destroy_kmem_cache:
> 	...
> 	return ret;
> }
> 

Thank you for suggestion.
I think you are worrying about missing the information who makes 'ret' non-zero.
Ok. I will process it separately.

thanks

KyongHo.
> Best regards,
> Tomasz
> 
