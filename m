Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IQMhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:37:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57044 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:37:37 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-97-52384d0fe6f0
From: Tomasz Figa <t.figa@samsung.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        tglx@linutronix.de, thomas.ab@samsung.com
Subject: Re: [PATCH] irqchip: exynos-combiner: remove hard-coded irq_base value
Date: Tue, 17 Sep 2013 14:37:27 +0200
Message-id: <2060959.cLD86Prq58@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379309482-19779-1-git-send-email-chander.kashyap@linaro.org>
References: <1379309482-19779-1-git-send-email-chander.kashyap@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xa7r8vhZBBjcvGFk8XH+TxaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBabN01ltuhYxujA7nHn2h42j3fnzrF7bF5S79G3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZU7YfYS64ylUx6eg1lgbGaxxdjJwcEgImEl2ndzJB2GISF+6tZ+ti
	5OIQEljKKPHx+hMmCKeLSeLO0q8sIFVsAmoSnxsesYHYIgIGEut2NTGC2MwC6xklru9W72Lk
	4BAW8Je4OzEfJMwioCqxcdNvsAW8ApoSz87/Ywex+QXUJd5tewoWFxVwlfi0cCNYnFPAW2LL
	yh1gtpCAl8S5y2ehegUlfky+xwKxSl5i3/6prBC2lsT6nceZJjAKzkJSNgtJ2SwkZQsYmVcx
	iqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihAT+lx2Mi49ZHWIU4GBU4uH9IGMeJMSaWFZcmXuI
	UYKDWUmEN5TFIkiINyWxsiq1KD++qDQntfgQIxMHp1QDo4u+46oNJx6vatqveVnid5nYcs/0
	WuH4vL8FHTLvW1dk7HjLVHBK9pK9yg+Bs4GbG87mzhX64PzMeK/eufrFzTrCMQKXG9Ye501k
	yrA5vs6BcXEH96cngt9W3G7ZmRC2dPrt1pKLD2+uzt8Uts9tyQL7FEeOx88KzayenGeUe6+1
	Qis1MWFGphJLcUaioRZzUXEiAP5Hzi5aAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chander,

On Monday 16 of September 2013 11:01:22 Chander Kashyap wrote:
> Pass '0' in place of hardcoded "irq_base" value as "first_irq" parameter
> to "irq_domain_add_simple" in order to use linear irq domain.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> ---
>  drivers/irqchip/exynos-combiner.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/irqchip/exynos-combiner.c
> b/drivers/irqchip/exynos-combiner.c index 4c68265..b4ed356 100644
> --- a/drivers/irqchip/exynos-combiner.c
> +++ b/drivers/irqchip/exynos-combiner.c
> @@ -206,8 +206,7 @@ static unsigned int combiner_lookup_irq(int group)
> 
>  static void __init combiner_init(void __iomem *combiner_base,
>  				 struct device_node *np,
> -				 unsigned int max_nr,
> -				 int irq_base)
> +				 unsigned int max_nr)
>  {
>  	int i, irq;
>  	unsigned int nr_irq;
> @@ -221,7 +220,7 @@ static void __init combiner_init(void __iomem
> *combiner_base, return;
>  	}
> 
> -	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
> +	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, 0,
>  				&combiner_irq_domain_ops, combiner_data);

I believe you can safely go with calling irq_domain_add_linear() directly 
here.

Otherwise the patch looks good.

Best regards,
Tomasz

