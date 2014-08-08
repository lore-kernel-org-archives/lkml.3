Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaHHHs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:48:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42250 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaHHHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:48:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-7b-53e480e47d82
Content-transfer-encoding: 8BIT
Message-id: <1407484136.21474.8.camel@AMDC1943>
Subject: Re: [PATCH] mfd: sec-irq: fix support for devices without irq specified
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Date: Fri, 08 Aug 2014 09:48:56 +0200
In-reply-to: <1407483274.21474.1.camel@AMDC1943>
References: <22704524.WE4thfvSda@amdc1032> <1471646.xbSCysvkpT@amdc1032>
 <1407483274.21474.1.camel@AMDC1943>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xK7pPGp4EG0z7r22xccZ6VouzTW/Y
	Le5/PcpocXnXHDaLGef3MVmc7ma1uLjiC5MDu8eda3vYPOadDPTo27KK0ePzJrkAligum5TU
	nMyy1CJ9uwSujDOX3zIVLBeoeH+vuIFxLm8XIyeHhICJxK/fi1kgbDGJC/fWs3UxcnEICSxl
	lLj//A0TSIJXQFDix+R7QEUcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mVFiwtQuqHp9iZuL1rGD
	2MICARJ/lu4Di7MJGEtsXr6EDcQWEbCQWLviLQtIM7PAPaDm9RdZQRIsAqoSe27cBbM5BQwk
	Tt1uAbtOSCBP4vHilYwQlypLzNt/jGkCo8AsJPfNQrhvFpL7FjAyr2IUTS1NLihOSs810itO
	zC0uzUvXS87P3cQICeqvOxiXHrM6xCjAwajEw6uw926wEGtiWXFl7iFGCQ5mJRHems+Pg4V4
	UxIrq1KL8uOLSnNSiw8xMnFwSjUwHmI/NfNzx9Vav5bIvE+ZKw9dPlLAd5lLVnR91yLtij3W
	V2alBTzhOzBt+eac4yUX27L/iarNKcnlnnNrxde+ysP5D9O4xOVjvU7vieN7Y/DlLc/vnTv+
	rMlxN1vh2vmJ880Zza7SBNUdz9ariTl8VGRNcnKXNRW4+5Klf4mql77EtAwFM743SizFGYmG
	WsxFxYkA1EKqCUgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-08-08 at 09:34 +0200, Krzysztof Kozlowski wrote:
> On czw, 2014-08-07 at 18:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> > [ added missing linux-samsung-soc ML, sorry for the noise ]
> > 
> > On Thursday, August 07, 2014 06:42:28 PM Bartlomiej Zolnierkiewicz wrote:
> > > Add missing check for the case of device without irq specified
> > > in sec_irq_exit() (please note that sec_irq_init() already
> > > correctly handles such devices).
> > > 
> > > This is needed for Insignal's Exynos4412 based Origen board.
> > > 
> > > Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Sangbeom Kim <sbkim73@samsung.com>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > > patch is against next-20140804 branch of linux-next kernel
> > > 
> > >  drivers/mfd/sec-irq.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> Looks and works good (tested on board with S2MPS14).
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Best regards,
> Krzysztof
> 
> > > 
> > > diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> > > index f9a5786..b65a7f0 100644
> > > --- a/drivers/mfd/sec-irq.c
> > > +++ b/drivers/mfd/sec-irq.c
> > > @@ -478,5 +478,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
> > >  
> > >  void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
> > >  {
> > > -	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> > > +	if (sec_pmic->irq)
> > > +		regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> > >  }

Seems I jumped too far with this one. Patch looks OK and works fine but
is it really needed? If (!sec_pmic->irq) then sec_pmic->irq_data will be
NULL and regmap_del_irq_chip() will handle it correctly.

Your change adds some sense of precautions (the sec_pmic->irq_data may
be set by some other module by mistake) but still it does not look like
"needed" for Origen.

Best regards,
Krzysztof

