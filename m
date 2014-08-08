Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaHHHej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:34:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11278 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaHHHec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:34:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-52-53e47d8645ca
Message-id: <1407483274.21474.1.camel@AMDC1943>
Subject: Re: [PATCH] mfd: sec-irq: fix support for devices without irq specified
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Date: Fri, 08 Aug 2014 09:34:34 +0200
In-reply-to: <1471646.xbSCysvkpT@amdc1032>
References: <22704524.WE4thfvSda@amdc1032> <1471646.xbSCysvkpT@amdc1032>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xy7pttU+CDSavkbDYOGM9q8XZpjfs
	Fve/HmW0uLxrDpvFjPP7mCxOd7NaXFzxhcmB3ePOtT1sHvNOBnr0bVnF6PF5k1wASxSXTUpq
	TmZZapG+XQJXxsItW9kLWnkqTs/Yz9rA+IOzi5GTQ0LARKLr20xWCFtM4sK99WwgtpDAUkaJ
	61uiIezPjBKzD3uB2LwC+hK/u/czgdjCAgESf5buA7PZBIwlNi9fAtYrImAhsXbFW5YuRi4O
	ZoF7jBIT1l8EW8AioCox/cYlRhCbU0BL4sa3x4wQCzwktn3sBmtmFlCXmDRvETPEQcoS8/Yf
	Y4JYLCjxY/I9FogaeYnNa94yT2AUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L
	10vOz93ECAnrLzsYFx+zOsQowMGoxMNrcPpusBBrYllxZe4hRgkOZiUR3prPj4OFeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MFrl6phc3/XVxuPKq0kz7i/JSWhX7rlx19D59e6/j7+/df3p3X7U
	fDnTrpvRdkLH3rTus7DZvvYNZ8CGByEm714aiVSzZJ8/bVJyr/RpI0dP1+mYrfueH95ddGHX
	RYd3xbdff7utW/TFyvjx8c1rp8/0tC3o4e43XJSnlDqzy5Zddb3++xUKhklKLMUZiYZazEXF
	iQAJxUnBSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-08-07 at 18:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> [ added missing linux-samsung-soc ML, sorry for the noise ]
> 
> On Thursday, August 07, 2014 06:42:28 PM Bartlomiej Zolnierkiewicz wrote:
> > Add missing check for the case of device without irq specified
> > in sec_irq_exit() (please note that sec_irq_init() already
> > correctly handles such devices).
> > 
> > This is needed for Insignal's Exynos4412 based Origen board.
> > 
> > Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Sangbeom Kim <sbkim73@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > patch is against next-20140804 branch of linux-next kernel
> > 
> >  drivers/mfd/sec-irq.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)

Looks and works good (tested on board with S2MPS14).

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> > 
> > diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> > index f9a5786..b65a7f0 100644
> > --- a/drivers/mfd/sec-irq.c
> > +++ b/drivers/mfd/sec-irq.c
> > @@ -478,5 +478,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
> >  
> >  void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
> >  {
> > -	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> > +	if (sec_pmic->irq)
> > +		regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> >  }

