Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaHHHeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:34:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41188 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHHHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:34:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f3-53e47d6a2622
Message-id: <1407483246.21474.0.camel@AMDC1943>
Subject: Re: [PATCH] mfd: sec-core: add missing sec_irq_init() return value
 checking
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Date: Fri, 08 Aug 2014 09:34:06 +0200
In-reply-to: <2156078.GxeZgK3rLH@amdc1032>
References: <2486284.NeLpWWu75g@amdc1032> <2156078.GxeZgK3rLH@amdc1032>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xy7pZtU+CDTYsN7TYOGM9q8XZpjfs
	Fve/HmW0uLxrDpvFjPP7mCxOd7NaXFzxhcmB3ePOtT1sHvNOBnr0bVnF6PF5k1wASxSXTUpq
	TmZZapG+XQJXxpz7e5kLpvBUvH73g72B8SdnFyMnh4SAicSlnkmsELaYxIV769m6GLk4hASW
	Mkqs3nOLHcL5zCjR8monG0gVr4C+xPOmhWAdwgJhEn0bnrKA2GwCxhKbly8BqxERsJBYu+It
	C0gzs8A9RokJ6y+CNbAIqEqc29kKZHNwcApoSdzbbAUSFhJwl2j4upkdxGYWUJeYNG8RM8RF
	yhLz9h9jgtgrKPFj8j0WiBp5ic1r3jJPYBSYhaRlFpKyWUjKFjAyr2IUTS1NLihOSs811CtO
	zC0uzUvXS87P3cQICewvOxgXH7M6xCjAwajEw2tw+m6wEGtiWXFl7iFGCQ5mJRHems+Pg4V4
	UxIrq1KL8uOLSnNSiw8xMnFwSjUwthRrV6sI/Jl10L5nY0nzv4unJzHOcDy2XrvIP8rodWTA
	acHDEQ9Uw47aBEi5xVi+ttbibZ4hoRf32Gg24+kL8vvLpVdlX//C7f7//iRHyxPH/d8tmBg0
	qSXzOuv1pNvTP5wuqNuWd+Ze7+eInS9qi1gmbVBjeZP7Tefuhz19VxL37T799vOdGUosxRmJ
	hlrMRcWJAAnE8KxKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-08-07 at 18:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> [ added missing linux-samsung-soc ML, sorry for the noise ]
> 
> On Thursday, August 07, 2014 06:44:18 PM Bartlomiej Zolnierkiewicz wrote:
> > sec_irq_init() can fail if it encounters unknown device type or
> > on regmap_add_irq_chip() error.  Add missing sec_irq_init() return
> > value checking to sec_pmic_probe().
> > 
> > Tested on Insignal's Exynos4412 based Origen board.
> > 
> > Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Sangbeom Kim <sbkim73@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > patch is against next-20140804 branch of linux-next kernel
> > 
> >  drivers/mfd/sec-core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)

Looks and works good (tested on board with S2MPS14).

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> > 
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > index dba7e2b..f498867 100644
> > --- a/drivers/mfd/sec-core.c
> > +++ b/drivers/mfd/sec-core.c
> > @@ -353,7 +353,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> >  	if (pdata && pdata->cfg_pmic_irq)
> >  		pdata->cfg_pmic_irq();
> >  
> > -	sec_irq_init(sec_pmic);
> > +	ret = sec_irq_init(sec_pmic);
> > +	if (ret)
> > +		return ret;
> >  
> >  	pm_runtime_set_active(sec_pmic->dev);

