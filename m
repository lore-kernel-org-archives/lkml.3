Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3GOKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:20:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65435 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3GOKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:20:36 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-75-51e3ccf2bf1e
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
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
        "'Grant Grundler'" <grundler@chromium.org>
References: <002d01ce797b$49c441a0$dd4cc4e0$@samsung.com>
 <13890783.WKk2X4EVm4@amdc1032>
In-reply-to: <13890783.WKk2X4EVm4@amdc1032>
Subject: RE: [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
Date: Mon, 15 Jul 2013 19:20:34 +0900
Message-id: <009301ce8144$f1172c30$d3458490$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJbPTAfBQ+cxpXUnojbERvKquuJ7QIw34gkmDqINKA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zge6nM48DDVYvNLLYOGM9q8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APYrLJiU1J7MstUjf
	LoErY9HZHpaCKXoVe9bvZ2xgnKDaxcjJISFgIrFoxgFGCFtM4sK99WwgtpDAMkaJrXPMuxjZ
	wWrWlXUxcgFFpzNK3D72hA3C+csosbfpPTNIPZuAlsTqucfB5ogIWEk8nnGWHaSIWWAzi0RX
	/xIWiKFREi9mdbKD2JwC2hJnG5axgtjCAs4Sr06cAYuzCKhKPL4McQSvgKXE008/mCBsQYkf
	k++BzWEGWrZ+53EmCFteYvOat8wQDyhI7Dj7Gu6IKaf+MEPUiEjse/EO6smlHBLz57NB7BKQ
	+Db5ENBMDqC4rMSmA1BjJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJBsWMLKsYhRNLUguKE5KLzLU
	K07MLS7NS9dLzs/dxAhJA707GG8fsD7EmAy0fiKzlGhyPjCN5JXEGxqbGVmYmpgaG5lbmpEm
	rCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUWqRreTPh0uPLBLdy+uyevWTUoYy
	1v07hW3j1bqkP3ra133SsZpin9X272BJ8e1nk1OWV/IsP6pVGn5wS6tV164M3icKp9t2fZwz
	fWVocs2RCRv2Ozn8VDbb8vS/zJoNgWv/c1WXlcwvEldfsnXV4vjL5oLqgdzaMjbvOM/8EXZ4
	tuuvUd/0hUosxRmJhlrMRcWJABODt1gZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jQd1PZx4HGkz6q22xccZ6VotXR34w
	WSzYb23ROXsDu8Xmg+tYLHoXXGWzaLw3gc1i0+NrrBaXd81hs5hxfh+TxYUVG9ktpiw6zGrR
	cr2XyYHX48nBeUwesxsusnjcubaHzWPzknqPyTeWM3r0bVnF6PF5k1wAe1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0LVKCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxFZ3tYCqboVexZv5+xgXGCahcjO4eEgInEurIu
	Rk4gS0ziwr31bF2MXBxCAtMZJW4fewLl/GWU2Nv0nhmkik1AS2L13OOMILaIgJXE4xln2UGK
	mAU2s0h09S9hAUkICURJvJjVyQ5icwpoS5xtWMYKYgsLOEu8OnEGLM4ioCrx+DLIOk4OXgFL
	iaeffjBB2IISPybfA5vDDLRs/c7jTBC2vMTmNW+ZIU5VkNhx9jXcEVNO/WGGqBGR2PfiHeME
	RqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnGieSe9gXNVg
	cYhRgINRiYc3Q+1xoBBrYllxZe4hRgkOZiUR3mXKjwKFeFMSK6tSi/Lji0pzUosPMSYDfTqR
	WUo0OR+YBPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVF2
	zhyuCqGmsLM3WXfKbKoO++T27pOTiknBi0cZB+K91OUvrzkTlV+w52DXY2bv857nrt3su+Dw
	Y0u/8KlJ76tfT8uT8n8SZGpauM/h1PFlMr4SvB222tMmKRm5vqtYIfd4t0XMnrbnKQndIjPV
	nd4emM5Um5570vb8y4fF4ln5l0QPb5CJ61BiKc5INNRiLipOBABbDVqweAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Saturday, July 13, 2013 12:31 AM
> 
> Hi,
> 
> On Friday, July 05, 2013 09:29:26 PM Cho KyongHo wrote:
> > Since acquiring read_lock is not more frequent than write_lock, it is
> > not beneficial to use rwlock, this commit changes rwlock to spinlock.
> 
> This change is not of a "fix type" and is not required to make the driver
> work so it would probably be best to move it to the end of a patch series
> (IOW just making it the last patch in the series).
> 

Thank you for advice.
I will do that in the next patchset :)

Cho KyongHo.

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   32 ++++++++++++++++----------------
> >  1 files changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 390f8b7..6793661 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -175,7 +175,7 @@ struct sysmmu_drvdata {
> >  	void __iomem **sfrbases;
> >  	struct clk *clk[2];
> >  	int activations;
> > -	rwlock_t lock;
> > +	spinlock_t lock;
> >  	struct iommu_domain *domain;
> >  	sysmmu_fault_handler_t fault_handler;
> >  	unsigned long pgtable;
> > @@ -259,7 +259,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  	BUG_ON((base0 + size0) <= base0);
> >  	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
> >
> > -	read_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >  	if (!is_sysmmu_active(data))
> >  		goto finish;
> >
> > @@ -289,7 +289,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  		}
> >  	}
> >  finish:
> > -	read_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  static void __set_fault_handler(struct sysmmu_drvdata *data,
> > @@ -297,9 +297,9 @@ static void __set_fault_handler(struct sysmmu_drvdata *data,
> >  {
> >  	unsigned long flags;
> >
> > -	write_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >  	data->fault_handler = handler;
> > -	write_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  void exynos_sysmmu_set_fault_handler(struct device *dev,
> > @@ -347,7 +347,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >
> >  	int i, ret = -ENOSYS;
> >
> > -	read_lock(&data->lock);
> > +	spin_lock(&data->lock);
> >
> >  	WARN_ON(!is_sysmmu_active(data));
> >
> > @@ -391,7 +391,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  	if (itype != SYSMMU_FAULT_UNKNOWN)
> >  		sysmmu_unblock(data->sfrbases[i]);
> >
> > -	read_unlock(&data->lock);
> > +	spin_unlock(&data->lock);
> >
> >  	return IRQ_HANDLED;
> >  }
> > @@ -402,7 +402,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> >  	bool disabled = false;
> >  	int i;
> >
> > -	write_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >
> >  	if (!set_sysmmu_inactive(data))
> >  		goto finish;
> > @@ -419,7 +419,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> >  	data->pgtable = 0;
> >  	data->domain = NULL;
> >  finish:
> > -	write_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >
> >  	if (disabled)
> >  		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
> > @@ -442,7 +442,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> >  	int i, ret = 0;
> >  	unsigned long flags;
> >
> > -	write_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >
> >  	if (!set_sysmmu_active(data)) {
> >  		if (WARN_ON(pgtable != data->pgtable)) {
> > @@ -481,7 +481,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> >
> >  	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
> >  finish:
> > -	write_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >
> >  	return ret;
> >  }
> > @@ -528,7 +528,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
> >  	unsigned long flags;
> >  	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> >
> > -	read_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >
> >  	if (is_sysmmu_active(data)) {
> >  		int i;
> > @@ -545,7 +545,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
> >  			data->dbgname);
> >  	}
> >
> > -	read_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  void exynos_sysmmu_tlb_invalidate(struct device *dev)
> > @@ -553,7 +553,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >  	unsigned long flags;
> >  	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> >
> > -	read_lock_irqsave(&data->lock, flags);
> > +	spin_lock_irqsave(&data->lock, flags);
> >
> >  	if (is_sysmmu_active(data)) {
> >  		int i;
> > @@ -569,7 +569,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >  			data->dbgname);
> >  	}
> >
> > -	read_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  static int exynos_sysmmu_probe(struct platform_device *pdev)
> > @@ -666,7 +666,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >  	}
> >
> >  	data->sysmmu = dev;
> > -	rwlock_init(&data->lock);
> > +	spin_lock_init(&data->lock);
> >  	INIT_LIST_HEAD(&data->node);
> >
> >  	__set_fault_handler(data, &default_fault_handler);

