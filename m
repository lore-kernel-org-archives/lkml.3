Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab3GLPar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:30:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57405 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3GLPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:30:45 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-cd-51e0212301c6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
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
Subject: Re: [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
Date: Fri, 12 Jul 2013 17:30:33 +0200
Message-id: <13890783.WKk2X4EVm4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <002d01ce797b$49c441a0$dd4cc4e0$@samsung.com>
References: <002d01ce797b$49c441a0$dd4cc4e0$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgK6y4oNAg2ffzC1eHfnBZLFgv7VF
	5+wN7BabD65jsehdcJXNovHeBDaLTY+vsVpc3jWHzWLG+X1MFhdWbGS3+Nd7kNFiyqLDrBYt
	13uZHHg9nhycx+Qxu+Eii8eda3vYPDYvqfeYfGM5o0ffllWMHp83yQWwR3HZpKTmZJalFunb
	JXBlHHvNW3BQq2LHpRtMDYwXlboYOTkkBEwkfp64ygphi0lcuLeerYuRi0NIYBGjRNuiS4wQ
	TguTRPOFw4wgVWwCVhIT21eB2SICGhKfr6xnBSliFtjMItHVv4QFJCEs4Cxx7+d8dhCbRUBV
	4u/rfWA2r4CWxIprHWDNogL2EtvevWUDsTmBhp79vhksLiRgKdF78A4LRL2gxI/J98BsZgF5
	iX37p7JC2FoS63ceZ5rAKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcM8+kdjCubLA4xCjAwajEw+sg+iBQiDWxrLgy9xCjBAezkgjvTbP7gUK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoY87mqJ8venhX08dKp1mP7nE/X
	/OhgC5m2sVJSU2XHU887M0PCa/y+PhGa+7ZnX/eUEL0dHFmuZ+6+mNFoZHqVvTT+UUnNaUbN
	yN2H9c7Vipez/k1yv9gmxT/97Knqv93XHnJM77IT3VT9dsk5V6EMy32Ct6raRRqDtDsjvy7y
	jVu6ZklyfoiJEktxRqKhFnNRcSIATG2Q/JUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, July 05, 2013 09:29:26 PM Cho KyongHo wrote:
> Since acquiring read_lock is not more frequent than write_lock, it is
> not beneficial to use rwlock, this commit changes rwlock to spinlock.

This change is not of a "fix type" and is not required to make the driver
work so it would probably be best to move it to the end of a patch series
(IOW just making it the last patch in the series).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 390f8b7..6793661 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -175,7 +175,7 @@ struct sysmmu_drvdata {
>  	void __iomem **sfrbases;
>  	struct clk *clk[2];
>  	int activations;
> -	rwlock_t lock;
> +	spinlock_t lock;
>  	struct iommu_domain *domain;
>  	sysmmu_fault_handler_t fault_handler;
>  	unsigned long pgtable;
> @@ -259,7 +259,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>  	BUG_ON((base0 + size0) <= base0);
>  	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
>  
> -	read_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  	if (!is_sysmmu_active(data))
>  		goto finish;
>  
> @@ -289,7 +289,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>  		}
>  	}
>  finish:
> -	read_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  }
>  
>  static void __set_fault_handler(struct sysmmu_drvdata *data,
> @@ -297,9 +297,9 @@ static void __set_fault_handler(struct sysmmu_drvdata *data,
>  {
>  	unsigned long flags;
>  
> -	write_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  	data->fault_handler = handler;
> -	write_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  }
>  
>  void exynos_sysmmu_set_fault_handler(struct device *dev,
> @@ -347,7 +347,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>  
>  	int i, ret = -ENOSYS;
>  
> -	read_lock(&data->lock);
> +	spin_lock(&data->lock);
>  
>  	WARN_ON(!is_sysmmu_active(data));
>  
> @@ -391,7 +391,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>  	if (itype != SYSMMU_FAULT_UNKNOWN)
>  		sysmmu_unblock(data->sfrbases[i]);
>  
> -	read_unlock(&data->lock);
> +	spin_unlock(&data->lock);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -402,7 +402,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
>  	bool disabled = false;
>  	int i;
>  
> -	write_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  
>  	if (!set_sysmmu_inactive(data))
>  		goto finish;
> @@ -419,7 +419,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
>  	data->pgtable = 0;
>  	data->domain = NULL;
>  finish:
> -	write_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  
>  	if (disabled)
>  		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
> @@ -442,7 +442,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
>  	int i, ret = 0;
>  	unsigned long flags;
>  
> -	write_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  
>  	if (!set_sysmmu_active(data)) {
>  		if (WARN_ON(pgtable != data->pgtable)) {
> @@ -481,7 +481,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
>  
>  	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
>  finish:
> -	write_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  
>  	return ret;
>  }
> @@ -528,7 +528,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>  	unsigned long flags;
>  	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
>  
> -	read_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  
>  	if (is_sysmmu_active(data)) {
>  		int i;
> @@ -545,7 +545,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>  			data->dbgname);
>  	}
>  
> -	read_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  }
>  
>  void exynos_sysmmu_tlb_invalidate(struct device *dev)
> @@ -553,7 +553,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>  	unsigned long flags;
>  	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
>  
> -	read_lock_irqsave(&data->lock, flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  
>  	if (is_sysmmu_active(data)) {
>  		int i;
> @@ -569,7 +569,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>  			data->dbgname);
>  	}
>  
> -	read_unlock_irqrestore(&data->lock, flags);
> +	spin_unlock_irqrestore(&data->lock, flags);
>  }
>  
>  static int exynos_sysmmu_probe(struct platform_device *pdev)
> @@ -666,7 +666,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
>  	}
>  
>  	data->sysmmu = dev;
> -	rwlock_init(&data->lock);
> +	spin_lock_init(&data->lock);
>  	INIT_LIST_HEAD(&data->node);
>  
>  	__set_fault_handler(data, &default_fault_handler);

