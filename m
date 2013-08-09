Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967734Ab3HIHmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:42:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16075 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967262Ab3HIHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:42:07 -0400
X-AuditID: cbfee68f-b7f436d000000f81-16-52049d4dc0b0
Date: Fri, 09 Aug 2013 16:42:04 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
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
Subject: Re: [PATCH v9 08/16] iommu/exynos: gating clocks of master H/W
Message-id: <20130809164204.49dc7fb10c5d5d9480db75b7@samsung.com>
In-reply-to: <7908536.azGeeOL56k@flatron>
References: <002c01ce941b$1fd0ab80$5f720280$@samsung.com>
 <7908536.azGeeOL56k@flatron>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zY13fuSxBBq9+MlncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlms2vWH0YHf48nBeUwesxsusnjsnHWX3ePOtT1sHuc3rWH22Lyk3mPyjeWMHn1b
	VjF6fN4k53Hl6BmmAK4oLpuU1JzMstQifbsErozHr08zFazTrZgz5x9LA+Ni5S5GDg4JAROJ
	xiaLLkZOIFNM4sK99WxdjFwcQgLLGCVmND9jgkiYSNxfthzMFhJYxChxvs8AomgSk8S5+zfZ
	QBIsAqoSe/e/ZgGx2QS0JFbPPc4IYosIqEt8m9LPDmIzC/xgkfi0jQ/EFhZwl5h0Zg4ziM0r
	4Chx/t8GVhCbU0BT4vj5iYwQyyIkDjRcYoY4wkLiQlMHO0S9oMSPyfdYIGZqSWze1sQKYctL
	bF7zlhnkOAmBlRwSB/susEIcJyDxbfIhFoiPZSU2HYCaKSlxcMUNlgmMYrOQjJ2FZOwsJGMX
	MDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ+f4djHcPWB9iTAZaOZFZSjQ5H5gy8kri
	DY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmPIgKjDW
	NOfxv8wvv3uOmrqpJ+RWP710xfJvBpuRwA31nrfy/V+mq9xpW661mvN6sFiF6QRJVpUH/FMC
	3uvWXthpfmyeDmtt2Z3Z9+defPB99g4V3oi9WzUnBSQlvzr+4F533ZrQI3Xvb1yUumsjvuDb
	9sR1VxqWTsqd3yP0YJIe62r2ibuWhiixFGckGmoxFxUnAgCQzeQqDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAV2fuSxBBicfW1rcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlms2vWH0YHf48nBeUwesxsusnjsnHWX3ePOtT1sHuc3rWH22Lyk3mPyjeWMHn1b
	VjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTc
	VFslF58AXbfMHKA3lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZj1+f
	ZipYp1sxZ84/lgbGxcpdjJwcEgImEveXLWeCsMUkLtxbzwZiCwksYpQ432fQxcgFZE9ikjh3
	/yZYgkVAVWLv/tcsIDabgJbE6rnHGUFsEQF1iW9T+tlBbGaBHywSn7bxgdjCAu4Sk87MYQax
	eQUcJc7/28AKYnMKaEocPz+REWJZhMSBhkvMEEdYSFxo6mCHqBeU+DH5HgvETC2JzduaWCFs
	eYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4pz6R2
	MK5ssDjEKMDBqMTDq7idOUiINbGsuDL3EKMEB7OSCO/2CSxBQrwpiZVVqUX58UWlOanFhxiT
	gaExkVlKNDkfmO7ySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFR39Z3DnOT4nNRTQZt+9sLb21sFu2PX856Mynn9L74j4GmXJuXHK+cdOsUQ3eW5eN7T7YZ
	pf/YfqC9ZZvk5ouZHNNnd207LFlfeazlRuDrKUpfUlZJKrRHTrN137Unq+922N4q/lVRhxIk
	e5jWWuc+1Ht6cZbYGTHhlbkHI2+oCzQWSe2WuH9ViaU4I9FQi7moOBEAgdHGIG0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 00:45:17 +0200, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On Thursday 08 of August 2013 18:39:05 Cho KyongHo wrote:
> > This patch gates clocks of master H/W as well as clocks of System MMU
> > if master clocks are specified.
> > 
> > Some Exynos SoCs (i.e. GScalers in Exynos5250) have dependencies in
> > the gating clocks of master H/W and its System MMU. If a H/W is the
> > case, accessing control registers of System MMU is prohibited unless
> > both of the gating clocks of System MMU and its master H/W.
> > 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   38
> > ++++++++++++++++++++++++++++++++++---- 1 files changed, 34
> > insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 0ee73e8..005a7ed 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -173,6 +173,7 @@ struct sysmmu_drvdata {
> >  	struct device *dev;	/* Owner of system MMU */
> >  	int nsfrs;
> >  	struct clk *clk;
> > +	struct clk *clk_master;
> >  	int activations;
> >  	rwlock_t lock;
> >  	struct iommu_domain *domain;
> > @@ -263,6 +264,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  	if (!is_sysmmu_active(data))
> >  		goto finish;
> > 
> > +	clk_enable(data->clk_master);
> > +
> >  	for (i = 0; i < data->nsfrs; i++) {
> >  		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 
> 3) {
> >  			if (!sysmmu_block(data->sfrbases[i]))
> > @@ -288,6 +291,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  			sysmmu_unblock(data->sfrbases[i]);
> >  		}
> >  	}
> > +
> > +	clk_disable(data->clk_master);
> >  finish:
> >  	read_unlock_irqrestore(&data->lock, flags);
> >  }
> > @@ -358,6 +363,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void
> > *dev_id) break;
> >  	}
> > 
> > +	clk_enable(data->clk_master);
> > +
> >  	if (i == pdev->num_resources) {
> >  		itype = SYSMMU_FAULT_UNKNOWN;
> >  	} else {
> > @@ -391,6 +398,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void
> > *dev_id) if (itype != SYSMMU_FAULT_UNKNOWN)
> >  		sysmmu_unblock(data->sfrbases[i]);
> > 
> > +	clk_disable(data->clk_master);
> > +
> >  	read_unlock(&data->lock);
> > 
> >  	return IRQ_HANDLED;
> > @@ -407,11 +416,14 @@ static bool __exynos_sysmmu_disable(struct
> > sysmmu_drvdata *data) if (!set_sysmmu_inactive(data))
> >  		goto finish;
> > 
> > +	clk_enable(data->clk_master);
> > +
> >  	for (i = 0; i < data->nsfrs; i++)
> >  		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + 
> REG_MMU_CTRL);
> > 
> > -	if (data->clk)
> > -		clk_disable(data->clk);
> > +	clk_disable(data->clk_master);
> > +
> > +	clk_disable(data->clk);
> > 
> >  	disabled = true;
> >  	data->pgtable = 0;
> > @@ -454,11 +466,12 @@ static int __exynos_sysmmu_enable(struct
> > sysmmu_drvdata *data, goto finish;
> >  	}
> > 
> > -	if (data->clk)
> > -		clk_enable(data->clk);
> > +	clk_enable(data->clk);
> > 
> >  	data->pgtable = pgtable;
> > 
> > +	clk_enable(data->clk_master);
> > +
> >  	for (i = 0; i < data->nsfrs; i++) {
> >  		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> > 
> > @@ -473,6 +486,8 @@ static int __exynos_sysmmu_enable(struct
> > sysmmu_drvdata *data, __raw_writel(CTRL_ENABLE, data->sfrbases[i] +
> > REG_MMU_CTRL); }
> > 
> > +	clk_disable(data->clk_master);
> > +
> >  	data->domain = domain;
> > 
> >  	dev_dbg(data->sysmmu, "Enabled\n");
> > @@ -528,6 +543,7 @@ static void sysmmu_tlb_invalidate_entry(struct
> > device *dev, unsigned long iova)
> > 
> >  	if (is_sysmmu_active(data)) {
> >  		int i;
> > +		clk_enable(data->clk_master);
> >  		for (i = 0; i < data->nsfrs; i++) {
> >  			if (sysmmu_block(data->sfrbases[i])) {
> >  				__sysmmu_tlb_invalidate_entry(
> > @@ -535,6 +551,7 @@ static void sysmmu_tlb_invalidate_entry(struct
> > device *dev, unsigned long iova) sysmmu_unblock(data->sfrbases[i]);
> >  			}
> >  		}
> > +		clk_disable(data->clk_master);
> >  	} else {
> >  		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating 
> TLB.\n");
> >  	}
> > @@ -551,12 +568,14 @@ void exynos_sysmmu_tlb_invalidate(struct device
> > *dev)
> > 
> >  	if (is_sysmmu_active(data)) {
> >  		int i;
> > +		clk_enable(data->clk_master);
> >  		for (i = 0; i < data->nsfrs; i++) {
> >  			if (sysmmu_block(data->sfrbases[i])) {
> >  				__sysmmu_tlb_invalidate(data-
> >sfrbases[i]);
> >  				sysmmu_unblock(data->sfrbases[i]);
> >  			}
> >  		}
> > +		clk_disable(data->clk_master);
> >  	} else {
> >  		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating 
> TLB.\n");
> >  	}
> > @@ -637,6 +656,17 @@ static int __init exynos_sysmmu_probe(struct
> > platform_device *pdev) return ret;
> >  	}
> > 
> > +	data->clk_master = devm_clk_get(dev, "master");
> > +	if (IS_ERR(data->clk_master))
> > +		data->clk_master = NULL;
> > +
> > +	ret = clk_prepare(data->clk_master);
> > +	if (ret) {
> > +		clk_unprepare(data->clk);
> > +		dev_err(dev, "Failed to prepare master's clk\n");
> > +		return ret;
> > +	}
> > +
> >  	rwlock_init(&data->lock);
> >  	INIT_LIST_HEAD(&data->node);
> 
> This should be done in a more appropriate way, but at the moment the PM 
> Core doesn't have any provision to implement any sane solution for this 
> kind of problems, so this is fine.
> 

I think it is just a work-around of H/W restriction that System MMU
can be accessed and work if the both clocks of System MMU and master IP
are ungated.
Exynos4210/4412 does not have the restriction.
Some H/W in Exynos5250, Exynos5420 have the restriction.

> Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Thanks.
> 
> Best regards,
> Tomasz
> 
