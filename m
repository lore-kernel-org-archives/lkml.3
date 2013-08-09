Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3HIEPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:15:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33243 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3HIEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:15:22 -0400
X-AuditID: cbfee691-b7fef6d000002d62-91-52046cd88e24
Date: Fri, 09 Aug 2013 13:15:20 +0900
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
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Message-id: <20130809131520.270b7be7454b1862b146e592@samsung.com>
In-reply-to: <1516548.d7oQuzQS7g@amdc1227>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
 <1516548.d7oQuzQS7g@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zY90bOSxBBmfXq1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVxdM1z9oJuy4rpB8sbGJ9rdzFyckgImEj073vFCmGL
	SVy4t56ti5GLQ0hgGaPEjrWH2WCKnuy8yASRmM4osfnrFBYIZxKTxL2v81hAqlgEVCXWHpkM
	ZrMJaEmsnnucEcQWEVCRuHxqOpjNLPCDReLTNr4uRg4OYQE3idZjgiBhXgFHiT0TL7GAhDmB
	Wrce1QcJCwlESjw7cZod4gYLiQtNHewQ5YISPybfY4GYqCWxeVsTK4QtL7F5zVtmkNMkBOZy
	SOyZtZcV4jQBiW+TD4HNlxCQldh0gBlipqTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0tSC5
	oDgpvchUrzgxt7g0L10vOT93EyMkzifuYLx/wPoQYzLQyonMUqLJ+cA0kVcSb2hsZmRhamJq
	bGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpDfzCfTnneuU1RaGHgl
	X9tlCWOHbI5ZhuKd46o+SVZp9VzZjyJ3blokLfA4+ROfw9pAGxW9mYGPP55pEVjFUhqsWCF7
	9Mpk6SmbUn4+3Z6/sTdjp9ExMetnalrnbnad/Tc3WdCmI0dtrwn/m/0ii3bLfju/2bvTuqZP
	dM9tu8nyVzQ4j8ttUWIpzkg01GIuKk4EABDqwHsJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQd0bOSxBBrcfylvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+ia5+wF3ZYV
	0w+WNzA+1+5i5OSQEDCReLLzIhOELSZx4d56ti5GLg4hgemMEpu/TmGBcCYxSdz7Oo8FpIpF
	QFVi7ZHJYDabgJbE6rnHGUFsEQEVicunpoPZzAI/WCQ+bePrYuTgEBZwk2g9JggS5hVwlNgz
	8RILSJgTqHXrUX2QsJBApMSzE6fZIW6wkLjQ1MEOUS4o8WPyPRaIiVoSm7c1sULY8hKb17xl
	nsAoMAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxEnkntYFzZYHGI
	UYCDUYmHV3E7c5AQa2JZcWXuIUYJDmYlEd4XWUAh3pTEyqrUovz4otKc1OJDjMnAsJjILCWa
	nA9McHkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJi701lY
	jvn/pOR9F42js+OU19XLu3m+YQ/0ytLKLN1vra8ampgatNaeZ9GmVJ85yl8muN7yjGC9Y756
	7z+hMs97Gho8FxfdTO2Iqwz32nzodkGO92EP+5UnXWN+tYlvXNrv2rbs9eUZBjuyvF98zVnX
	3W3eaPAkLaiuOsTNaofDm+S4A2tylFiKMxINtZiLihMBAbvE/2YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 15:54:50 +0200, Tomasz Figa wrote:
> On Thursday 08 of August 2013 18:37:43 Cho KyongHo wrote:
> > This prevents allocating lv2 page table for the lv1 page table entry
>   ^ What this is this this about? :)
> 
As you might indicate, 'this' means this patch :)

> > that already has 1MB page mapping. In addition, changed to BUG_ON
> > instead of returning -EADDRINUSE.
> 
> The change mentioned in last sentence should be a separate patch.
> 
Ok :)

> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   68
> > ++++++++++++++++++++++++----------------- 1 files changed, 40
> > insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index d545a25..d90e6fa 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -52,11 +52,11 @@
> >  #define lv2ent_large(pent) ((*(pent) & 3) == 1)
> > 
> >  #define section_phys(sent) (*(sent) & SECT_MASK)
> > -#define section_offs(iova) ((iova) & 0xFFFFF)
> > +#define section_offs(iova) ((iova) & ~SECT_MASK)
> >  #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
> > -#define lpage_offs(iova) ((iova) & 0xFFFF)
> > +#define lpage_offs(iova) ((iova) & ~LPAGE_MASK)
> >  #define spage_phys(pent) (*(pent) & SPAGE_MASK)
> > -#define spage_offs(iova) ((iova) & 0xFFF)
> > +#define spage_offs(iova) ((iova) & ~SPAGE_MASK)
> > 
> >  #define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
> >  #define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
> > @@ -856,13 +856,15 @@ finish:
> >  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long
> > iova, short *pgcounter)
> >  {
> > +	BUG_ON(lv1ent_section(sent));
> 
> Is this condition really a critical one, to the point that the system 
> should not continue execution?
> 
Discussed with Grant. He thought that creating mapping on a valid mapping
is just a BUG and I finally agreed with him. Is there a case that the condition
in BUG_ON is true intentionally?

> > +
> >  	if (lv1ent_fault(sent)) {
> >  		unsigned long *pent;
> > 
> >  		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> >  		if (!pent)
> > -			return NULL;
> > +			return ERR_PTR(-ENOMEM);
> > 
> >  		*sent = mk_lv1ent_page(__pa(pent));
> >  		*pgcounter = NUM_LV2ENTRIES;
> > @@ -875,15 +877,11 @@ static unsigned long *alloc_lv2entry(unsigned long
> > *sent, unsigned long iova,
> > 
> >  static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short
> > *pgcnt) {
> > -	if (lv1ent_section(sent))
> > -		return -EADDRINUSE;
> > +	BUG_ON(lv1ent_section(sent));
> 
> Ditto.
> 
> >  	if (lv1ent_page(sent)) {
> > -		if (*pgcnt != NUM_LV2ENTRIES)
> > -			return -EADDRINUSE;
> > -
> > +		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> 
> Ditto.
> 
> >  		kfree(page_entry(sent, 0));
> > -
> >  		*pgcnt = 0;
> >  	}
> > 
> > @@ -894,24 +892,24 @@ static int lv1set_section(unsigned long *sent,
> > phys_addr_t paddr, short *pgcnt) return 0;
> >  }
> > 
> > +static void clear_page_table(unsigned long *ent, int n)
> > +{
> > +	if (n > 0)
> > +		memset(ent, 0, sizeof(*ent) * n);
> > +}
> 
> I don't see the point of creating this function. It seems to be used only 
> once, in addition with a constant as n, so the check for n > 0 is 
> unnecessary.
> 
> And even if there is a need for this change, it should be done in separate 
> patch, as this one is not about stylistic changes, but fixing page table 
> maintenance (at least based on your commit message).
> 

I know what you are concerning about.
It was introduced in v8 patches to recover previous fault entries before
returning -EADDRINUSE. It is still remained though "return -EADDRINUSE"
is changed into BUG_ON().
I also think that it needs to be removed.

> >  static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t
> > size, short *pgcnt)
> >  {
> >  	if (size == SPAGE_SIZE) {
> > -		if (!lv2ent_fault(pent))
> > -			return -EADDRINUSE;
> > -
> > +		BUG_ON(!lv2ent_fault(pent));
> 
> Ditto.
> 
> >  		*pent = mk_lv2ent_spage(paddr);
> >  		pgtable_flush(pent, pent + 1);
> >  		*pgcnt -= 1;
> >  	} else { /* size == LPAGE_SIZE */
> >  		int i;
> >  		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
> > -			if (!lv2ent_fault(pent)) {
> > -				memset(pent, 0, sizeof(*pent) * i);
> > -				return -EADDRINUSE;
> > -			}
> > -
> > +			BUG_ON(!lv2ent_fault(pent));
> 
> Ditto.
> 
> >  			*pent = mk_lv2ent_lpage(paddr);
> >  		}
> >  		pgtable_flush(pent - SPAGES_PER_LPAGE, pent);
> > @@ -944,17 +942,16 @@ static int exynos_iommu_map(struct iommu_domain
> > *domain, unsigned long iova, pent = alloc_lv2entry(entry, iova,
> >  					&priv->lv2entcnt[lv1ent_offset(iova)]);
> > 
> > -		if (!pent)
> > -			ret = -ENOMEM;
> > +		if (IS_ERR(pent))
> > +			ret = PTR_ERR(pent);
> >  		else
> >  			ret = lv2set_page(pent, paddr, size,
> >  					&priv->lv2entcnt[lv1ent_offset(iova)]);
> >  	}
> > 
> > -	if (ret) {
> > -		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> > -							__func__, iova, size);
> > -	}
> > +	if (ret)
> > +		pr_err("%s: Failed(%d) to map 0x%#x bytes @ %#lx\n",
> > +			__func__, ret, size, iova);
> > 
> >  	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> > 
> > @@ -968,6 +965,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain
> > *domain, struct sysmmu_drvdata *data;
> >  	unsigned long flags;
> >  	unsigned long *ent;
> > +	size_t err_pgsize;
> > 
> >  	BUG_ON(priv->pgtable == NULL);
> > 
> > @@ -976,7 +974,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain
> > *domain, ent = section_entry(priv->pgtable, iova);
> > 
> >  	if (lv1ent_section(ent)) {
> > -		BUG_ON(size < SECT_SIZE);
> > +		if (WARN_ON(size < SECT_SIZE)) {
> > +			err_pgsize = SECT_SIZE;
> > +			goto err;
> > +		}
> > 
> >  		*ent = 0;
> >  		pgtable_flush(ent, ent + 1);
> > @@ -1008,9 +1009,12 @@ static size_t exynos_iommu_unmap(struct
> > iommu_domain *domain, }
> > 
> >  	/* lv1ent_large(ent) == true here */
> > -	BUG_ON(size < LPAGE_SIZE);
> > +	if (WARN_ON(size < LPAGE_SIZE)) {
> > +		err_pgsize = LPAGE_SIZE;
> > +		goto err;
> > +	}
> > 
> > -	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> > +	clear_page_table(ent, SPAGES_PER_LPAGE);
> 
> This seems to be the only use of the introduced clear_page_table() 
> function. Is there a need to replace the memset with it?
> 

Agree.

> >  	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> > 
> >  	size = LPAGE_SIZE;
> > @@ -1023,8 +1027,16 @@ done:
> >  		sysmmu_tlb_invalidate_entry(data->dev, iova);
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> > 
> > -
> >  	return size;
> > +err:
> > +	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> > +
> > +	pr_err("%s: Failed due to size(%#x) @ %#lx is"\
> > +		" smaller than page size %#x\n",
> > +		__func__, size, iova, err_pgsize);
> > +
> > +	return 0;
> > +
> 
> nit: Stray blank line.
> 
Oh. I didn't catch that.

Thanks.

KyongHo

> Best regards,
> Tomasz
> 
> >  }
> > 
> >  static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain
> > *domain,
