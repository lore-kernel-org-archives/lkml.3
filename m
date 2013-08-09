Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381Ab3HIIwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:52:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30339 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3HIIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:52:05 -0400
X-AuditID: cbfee68e-b7f276d000002279-c3-5204adac3f0d
Date: Fri, 09 Aug 2013 17:51:56 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
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
Message-id: <20130809175156.c7ffc68b865e4bca48ef47dd@samsung.com>
In-reply-to: <2101296.S6JDU5igl3@flatron>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
 <2544843.sndV7usHTj@amdc1227>
 <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
 <2101296.S6JDU5igl3@flatron>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zoe7atSxBBr+PM1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxWLVrj+MDgIeTw7OY/KY3XCRxWPnrLvsHneu7WHzOL9pDbPH5iX1HpNv
	LGf06NuyitHj8yY5jytHzzAFcEVx2aSk5mSWpRbp2yVwZdydUF4wV7NiXd9/9gbGVXJdjBwc
	EgImEl/+pHQxcgKZYhIX7q1nA7GFBJYxShxeoAIRN5F49ekLYxcjF1B8EaPEhT+7mCCcSUwS
	+/4cAOtgEVCV2PPoPSuIzSagJbF67nFGEFtEQF3i25R+dpAGZoE5rBJPli5jAUkICwRLbHr2
	E6yIV8BRYv2VTUwgNqeApsS8xjaoDRsYJRYs+sgKcYeFxIWmDnaIBkGJH5PvgQ1iBtq2eVsT
	K4QtL7F5zVtmkGYJgS0cEtdOnGaCOE9A4tvkQywQP8tKbDrADDFTUuLgihssExjFZiEZOwvJ
	2FlIxi5gZF7FKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERL/fTsYbx6wPsSYDLRyIrOUaHI+
	MH3klcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	wyOXJSvvT1yjE3nPu1KDt1rq7DlZk3Vrq84Iz+2/uUGG+3NQy0OWg4rfthkcuSdS7LjF1+nb
	XHa7tEyV60ZiX07bNnPWdXM95JDfsN9dQP9hUL/4lZL7D7KaNMxDc46+9bhSzvUjI16rbI3j
	nWMymhb5zRIC00QNNRofPRPfbm6oncfX26DEUpyRaKjFXFScCACVmjhKFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd01a1mCDL4dsbS4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVlcWLGR3WLKosOsFif/
	9DJatFzvZbJYP+M1i8WqXX8YHQQ8nhycx+Qxu+Eii8fOWXfZPe5c28PmcX7TGmaPzUvqPSbf
	WM7o0bdlFaPH501yHleOnmEK4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQw
	V1LIS8xNtVVy8QnQdcvMAfpFSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhY
	x5hxd0J5wVzNinV9/9kbGFfJdTFyckgImEi8+vSFEcIWk7hwbz1bFyMXh5DAIkaJC392MUE4
	k5gk9v05wAZSxSKgKrHn0XtWEJtNQEti9dzjYN0iAuoS36b0s4M0MAvMYZV4snQZC0hCWCBY
	YtOzn2BFvAKOEuuvbGICsTkFNCXmNbZBbdjAKLFg0UdWiDssJC40dbBDNAhK/Jh8D2wQM9C2
	zduaWCFseYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CE4wz6R3MK5qsDjEKMDBqMTDq7idOUiINbGsuDL3EKMEB7OSCO/2CSxBQrwpiZVVqUX58UWl
	OanFhxiTgeExkVlKNDkfmPzySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBa
	BLOFiYNTqoExIMsxLOOj+pktq89UOX1IO8T+8seyBTN+cty261R5tWDJ7mX8/qtUsiscpFaJ
	v17WIfmnYcnSMKOfNlddvMp/sS5ruH/j4RwHT+3MH//m8x2IEsio2N+yrWDOtSbBaqkLKsz6
	mpMW8zLPsm+rn2HEfzw9LLd1zzWT0Bv3tqVnblk1c8rPKJEaJZbijERDLeai4kQA7aujGHQD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 09:55:30 +0200, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On Friday 09 of August 2013 14:58:49 Cho KyongHo wrote:
> > On Thu, 08 Aug 2013 16:00:18 +0200, Tomasz Figa wrote:
> > > On Thursday 08 of August 2013 18:38:04 Cho KyongHo wrote:
> > > > Since kmalloc() does not guarantee that the allignment of 1KiB when
> > > > it
> > > > allocates 1KiB, it is required to allocate lv2 page table from own
> > > > slab that guarantees alignment of 1KiB
> > > > 
> > > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > > ---
> > > > 
> > > >  drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
> > > >  1 files changed, 20 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/iommu/exynos-iommu.c
> > > > b/drivers/iommu/exynos-iommu.c index d90e6fa..a318049 100644
> > > > --- a/drivers/iommu/exynos-iommu.c
> > > > +++ b/drivers/iommu/exynos-iommu.c
> > > > @@ -100,6 +100,8 @@
> > > > 
> > > >  #define REG_PB1_SADDR		0x054
> > > >  #define REG_PB1_EADDR		0x058
> > > > 
> > > > +static struct kmem_cache *lv2table_kmem_cache;
> > > > +
> > > > 
> > > >  static unsigned long *section_entry(unsigned long *pgtable,
> > > >  unsigned
> > > > 
> > > > long iova) {
> > > > 
> > > >  	return pgtable + lv1ent_offset(iova);
> > > > 
> > > > @@ -765,7 +767,8 @@ static void exynos_iommu_domain_destroy(struct
> > > > iommu_domain *domain)
> > > > 
> > > >  	for (i = 0; i < NUM_LV1ENTRIES; i++)
> > > >  	
> > > >  		if (lv1ent_page(priv->pgtable + i))
> > > > 
> > > > -			kfree(__va(lv2table_base(priv->pgtable + i)));
> > > > +			kmem_cache_free(lv2table_kmem_cache,
> > > > +					__va(lv2table_base(priv->pgtable + 
> i)));
> > > > 
> > > >  	free_pages((unsigned long)priv->pgtable, 2);
> > > >  	free_pages((unsigned long)priv->lv2entcnt, 1);
> > > > 
> > > > @@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned
> > > > long
> > > > *sent, unsigned long iova, if (lv1ent_fault(sent)) {
> > > > 
> > > >  		unsigned long *pent;
> > > > 
> > > > -		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> > > > +		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
> > > > 
> > > >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> > > >  		if (!pent)
> > > >  		
> > > >  			return ERR_PTR(-ENOMEM);
> > > > 
> > > > @@ -881,7 +884,7 @@ static int lv1set_section(unsigned long *sent,
> > > > phys_addr_t paddr, short *pgcnt)
> > > > 
> > > >  	if (lv1ent_page(sent)) {
> > > >  	
> > > >  		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> > > > 
> > > > -		kfree(page_entry(sent, 0));
> > > > +		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
> > > > 
> > > >  		*pgcnt = 0;
> > > >  	
> > > >  	}
> > > > 
> > > > @@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
> > > > 
> > > >  {
> > > >  
> > > >  	int ret;
> > > > 
> > > > +	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > > > +				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > > > +	if (!lv2table_kmem_cache) {
> > > > +		pr_err("%s: Failed to create kmem cache\n", __func__);
> > > > +		return -ENOMEM;
> > > > +	}
> > > > +
> > > > 
> > > >  	ret = platform_driver_register(&exynos_sysmmu_driver);
> > > >  	
> > > >  	if (ret == 0)
> > > > 
> > > > -		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > > > +		ret = bus_set_iommu(&platform_bus_type, 
> &exynos_iommu_ops);
> > > > +
> > > > +	if (ret) {
> > > > +		pr_err("%s: Failed to register exynos-iommu driver.\n",
> > > > +								__func__);
> > > > +		kmem_cache_destroy(lv2table_kmem_cache);
> > > > +	}
> > > 
> > > What about making the return value handling here cleaner? For example:
> > > 	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > > 	
> > > 				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > > 	
> > > 	if (!lv2table_kmem_cache) {
> > > 	
> > > 		...
> > > 		return -ENOMEM;
> > > 	
> > > 	}
> > > 	
> > > 	ret = platform_driver_register(&exynos_sysmmu_driver);
> > > 	if (ret) {
> > > 	
> > > 		...
> > > 		goto err_destroy_kmem_cache;
> > > 	
> > > 	}
> > > 	
> > > 	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > > 	if (ret) {
> > > 	
> > > 		...
> > > 		goto err_platform_unregister;
> > > 	
> > > 	}
> > > 	
> > > 	return 0;
> > > 
> > > err_platform_unregister:
> > > 	...
> > > 
> > > err_destroy_kmem_cache:
> > > 	...
> > > 	return ret;
> > > 
> > > }
> > 
> > Thank you for suggestion.
> > I think you are worrying about missing the information who makes 'ret'
> > non-zero.
> 
> Oh, this is a valid point, but it was more a nitpick about the coding 
> style. Single path error handling (with goto) is widely used in the kernel 
> in cases when more than one thing has to be undone and so I suggested this 
> method of error handling here as well.
> 
> > Ok. I will process it separately.
> 
> Since this patch adds most of the error handling to this function, I think 
> it should be fine to do it as a part of this patch.
> 

I meant 'separately' that checking all return values each.
I think it can be simpler without goto.
There are just 2 cases to rollback previous changes in that function.

> Best regards,
> Tomasz
> 
