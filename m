Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3G2JSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:18:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38417 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3G2JS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:18:28 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-79-51f633624461
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <003901ce89f3$126c0390$37440ab0$@samsung.com>
 <CANEJEGvp1msjkMLN-8TfykYXmrT+sq8dMkNsVEoh9i2vDoh=tg@mail.gmail.com>
In-reply-to: <CANEJEGvp1msjkMLN-8TfykYXmrT+sq8dMkNsVEoh9i2vDoh=tg@mail.gmail.com>
Subject: RE: [PATCH v8 03/12] iommu/exynos: fix page table maintenance
Date: Mon, 29 Jul 2013 18:18:25 +0900
Message-id: <004e01ce8c3c$9480f9d0$bd82ed70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQG5MPtiH1vdZYuCFQQ+0dTEPcH7vwHEp4A4mZfvXVA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zY90k42+BBjem81rcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujONNFxkLnllXPG75y97AuFOji5GTQ0LARGLJpG52
	CFtM4sK99WxdjFwcQgLLGCXWbN/NDFN0+c8UZojEIkaJ9zeXMEE4fxklJrY8YQKpYhPQklg9
	9zhjFyMHh4iAjsT8JfYgNcwCXawSP2cuhhrbwCjx7dtbsAZOgWCJ5+/XgO0WFnCTONj2nwmk
	mUVAVWL6Pj2QMK+ApcSHGweYIGxBiR+T77GAlDALqEtMmZILEmYWkJfYvOYt1KEKEjvOvmaE
	iItI7HvxDuocK4m7i2JBLpAQOMIh8WnzGlaQGhYBAYlvkw+BjZQQkJXYdABqjKTEwRU3WCYw
	SsxCsngWwuJZSBbPQrJsASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQdNG7g/H2AetD
	jMlA2ycyS4km5wPTTV5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGB20/3/w+NfyXOiT/cyiCRfv3GAXTDHdu134W9Tp/Ro//3zeJf5jfcgGs3/z
	8jiOircLf1OvvHniiOGjB38uzOaQz1m51sJA6eO1tmtpbsvad4ae8n8a9+/+8WVmb5ZLLL/6
	mX0m8+m6xXx87fJLLj5eqqepqnbO8cP3sz/YTdJsXnmGPF7WZKSvxFKckWioxVxUnAgA3hbY
	ay0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd0k42+BBusfslncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnHmy4yFjyz
	rnjc8pe9gXGnRhcjJ4eEgInE5T9TmCFsMYkL99azdTFycQgJLGKUeH9zCROE85dRYmLLEyaQ
	KjYBLYnVc48zdjFycIgI6EjMX2IPUsMs0MUq8XPmYqjuBkaJb9/egjVwCgRLPH+/hh3EFhZw
	kzjY9p8JpJlFQFVi+j49kDCvgKXEhxsHmCBsQYkfk++xgJQwC6hLTJmSCxJmFpCX2LzmLdSh
	ChI7zr5mhIiLSOx78Q7qHCuJu4tiJzAKzUIyaBbCoFlIBs1C0ryAkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnAyeia1g3Flg8UhRgEORiUe3odOXwKFWBPLiitzDzFKcDArifByGH0N
	FOJNSaysSi3Kjy8qzUktPsSYDPTlRGYp0eR8YKLMK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQZG71IL5aePdx65yc20s+77/+07impLPl/5dcvpZEbHr8+1
	6rNWTtpfeUzLf7blV7t0J9Pr9YeaEr0r9O78589cUS67XSDNT5o1VWCf4MV7EWaPN5XnnNzB
	9ehNf8Ftz3KuFz8zIo2XvN/vfX9S1jkh58K85q4PQUGRQpcLm1Yd2KV0QcBg7V4pJZbijERD
	Leai4kQA31SzQ4oDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Saturday, July 27, 2013 1:17 AM
> To: Cho KyongHo
> 
> On Fri, Jul 26, 2013 at 4:27 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > This prevents allocating lv2 page table for the lv1 page table entry
> > that already has 1MB page mapping. In addition some BUG_ON() is
> > changed to WARN_ON().
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> 
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> 
> In reviewing this, I noticed another issue that is related, but not
> caused by this patch. See below.
> 
> > ---
> >  drivers/iommu/exynos-iommu.c |   52 +++++++++++++++++++++++++++++------------
> >  1 files changed, 37 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index e3be3e5..6c4ecce 100644
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
> > @@ -862,12 +862,14 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> >                 pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> >                 BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> >                 if (!pent)
> > -                       return NULL;
> > +                       return ERR_PTR(-ENOMEM);
> >
> >                 *sent = mk_lv1ent_page(__pa(pent));
> >                 *pgcounter = NUM_LV2ENTRIES;
> >                 pgtable_flush(pent, pent + NUM_LV2ENTRIES);
> >                 pgtable_flush(sent, sent + 1);
> > +       } else if (lv1ent_section(sent)) {
> > +               return ERR_PTR(-EADDRINUSE);
> >         }
> >
> >         return page_entry(sent, iova);
> > @@ -894,6 +896,12 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
> >         return 0;
> >  }
> >
> > +static void clear_page_table(unsigned long *ent, int n)
> > +{
> > +       if (n > 0)
> > +               memset(ent, 0, sizeof(*ent) * n);
> > +}
> > +
> >  static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
> >                                                                 short *pgcnt)
> >  {
> > @@ -908,7 +916,7 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
> >                 int i;
> >                 for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
> >                         if (!lv2ent_fault(pent)) {
> > -                               memset(pent, 0, sizeof(*pent) * i);
> > +                               clear_page_table(pent - i, i);
> >                                 return -EADDRINUSE;
> 
> I am wondering about two issues with this error handling:
> 1) we don't call pgtable_flush() in this case - I think just for
> consistency we should - don't rush to add since my next comment is to
> change this error handling completely.
> 
clear_page_table() is called for the page table entries that are already
fault pages. That is why it does not contain cache flush.

> 2) If  -EADDRINUSE is correct, why does the code clear the IO Page
> table entries?
> 
>    I think this error path should either
>    (a) BUG_ON (ie panic) since this is an inconsistency between
> generic IOMMU page allocation and chip specific IOMMU mapping code OR
>    (b) WARN_ON, not clear the entries, and hope whoever was using it
> can finish using the system before crashing or gracefully shutting
> down.
> 
> In any case, I'm pretty sure this code needs to change and it should
> be in a follow up to this series.

Yes, you're right. But I worried the case that a kernel module calls IOMMU API
functions directly and does not want to make kernel panic when it tries to map
a region that is already in use.
I also wonder if the such kernel module exists.
WARN_ON is also a good idea.

Thank you.

> 
> thanks,
> grant
> 
> >                         }
> >
> > @@ -944,17 +952,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
> >                 pent = alloc_lv2entry(entry, iova,
> >                                         &priv->lv2entcnt[lv1ent_offset(iova)]);
> >
> > -               if (!pent)
> > -                       ret = -ENOMEM;
> > +               if (IS_ERR(pent))
> > +                       ret = PTR_ERR(pent);
> >                 else
> >                         ret = lv2set_page(pent, paddr, size,
> >                                         &priv->lv2entcnt[lv1ent_offset(iova)]);
> >         }
> >
> > -       if (ret) {
> > -               pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> > -                                                       __func__, iova, size);
> > -       }
> > +       if (ret)
> > +               pr_err("%s: Failed(%d) to map 0x%#x bytes @ %#lx\n",
> > +                       __func__, ret, size, iova);
> >
> >         spin_unlock_irqrestore(&priv->pgtablelock, flags);
> >
> > @@ -968,6 +975,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >         struct sysmmu_drvdata *data;
> >         unsigned long flags;
> >         unsigned long *ent;
> > +       size_t err_pgsize;
> >
> >         BUG_ON(priv->pgtable == NULL);
> >
> > @@ -976,7 +984,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >         ent = section_entry(priv->pgtable, iova);
> >
> >         if (lv1ent_section(ent)) {
> > -               BUG_ON(size < SECT_SIZE);
> > +               if (WARN_ON(size < SECT_SIZE)) {
> > +                       err_pgsize = SECT_SIZE;
> > +                       goto err;
> > +               }
> >
> >                 *ent = 0;
> >                 pgtable_flush(ent, ent + 1);
> > @@ -1008,9 +1019,12 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >         }
> >
> >         /* lv1ent_large(ent) == true here */
> > -       BUG_ON(size < LPAGE_SIZE);
> > +       if (WARN_ON(size < LPAGE_SIZE)) {
> > +               err_pgsize = LPAGE_SIZE;
> > +               goto err;
> > +       }
> >
> > -       memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> > +       clear_page_table(ent, SPAGES_PER_LPAGE);
> >         pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> >
> >         size = LPAGE_SIZE;
> > @@ -1023,8 +1037,16 @@ done:
> >                 sysmmu_tlb_invalidate_entry(data->dev, iova);
> >         spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -
> >         return size;
> > +err:
> > +       spin_unlock_irqrestore(&priv->pgtablelock, flags);
> > +
> > +       pr_err("%s: Failed due to size(%#x) @ %#lx is"\
> > +               " smaller than page size %#x\n",
> > +               __func__, size, iova, err_pgsize);
> > +
> > +       return 0;
> > +
> >  }
> >
> >  static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
> > --
> > 1.7.2.5
> >
> >

