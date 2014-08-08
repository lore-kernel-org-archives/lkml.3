Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbaHHMod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:44:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62095 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaHHMo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:44:28 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0f-53e4c62a270f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-irq: fix support for devices without irq specified
Date: Fri, 08 Aug 2014 14:44:20 +0200
Message-id: <2973458.9hVm8HXmvI@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1407484136.21474.8.camel@AMDC1943>
References: <22704524.WE4thfvSda@amdc1032> <1407483274.21474.1.camel@AMDC1943>
 <1407484136.21474.8.camel@AMDC1943>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jAV2tY0+CDSY9kbR4/cLQ4mzTG3aL
	+1+PMlpc3jWHzWLG+X1MFqe7WS0urvjC5MDucefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUn
	syy1SN8ugSujbfkb9oILIhX9rc9YGxgvC3QxcnJICJhIzD1ygx3CFpO4cG89WxcjF4eQwCJG
	ibP/H0M5LUwSHYuOMYFUsQlYSUxsX8UIYosIGEoc3L2dCaSIWeAeo8SE9RdZQRLCAgESf5bu
	A0pwcLAIqErM36ULEuYV0JSYPW8/G4gtKuApsWP7SjCbU8BAYvmvF2BXCAmUSNw41MkEUS8o
	8WPyPRYQm1lAW+LJuwusELa6xKR5i5gnMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEh/UzqR2MKxssDjEKcDAq8fAKdD8OFmJNLCuuzD3EKMHBrCTCe3n5k2Ah
	3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjGomd80T87/w
	TE946yqxmOnX8TPxDLcv/1H+v+7NiYtNc1y63jLfVr43U/S8SYDqtbZOJb2zjpuzjpzc1Rfm
	pDN9gvpTO2XmDWelDyzUdSyaXebxJe2fJ+Pry9GmzLfOna9dV6WyeKXzOe7st881v6t2a4eG
	lsl7tlVeXqsrfCouMW7r5jk+DUosxRmJhlrMRcWJAKMsy29nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 08, 2014 09:48:56 AM Krzysztof Kozlowski wrote:
> On pią, 2014-08-08 at 09:34 +0200, Krzysztof Kozlowski wrote:
> > On czw, 2014-08-07 at 18:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > [ added missing linux-samsung-soc ML, sorry for the noise ]
> > > 
> > > On Thursday, August 07, 2014 06:42:28 PM Bartlomiej Zolnierkiewicz wrote:
> > > > Add missing check for the case of device without irq specified
> > > > in sec_irq_exit() (please note that sec_irq_init() already
> > > > correctly handles such devices).
> > > > 
> > > > This is needed for Insignal's Exynos4412 based Origen board.
> > > > 
> > > > Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Cc: Sangbeom Kim <sbkim73@samsung.com>
> > > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > > ---
> > > > patch is against next-20140804 branch of linux-next kernel
> > > > 
> > > >  drivers/mfd/sec-irq.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > Looks and works good (tested on board with S2MPS14).
> > 
> > Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > 
> > Best regards,
> > Krzysztof
> > 
> > > > 
> > > > diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> > > > index f9a5786..b65a7f0 100644
> > > > --- a/drivers/mfd/sec-irq.c
> > > > +++ b/drivers/mfd/sec-irq.c
> > > > @@ -478,5 +478,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
> > > >  
> > > >  void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
> > > >  {
> > > > -	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> > > > +	if (sec_pmic->irq)
> > > > +		regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> > > >  }
> 
> Seems I jumped too far with this one. Patch looks OK and works fine but
> is it really needed? If (!sec_pmic->irq) then sec_pmic->irq_data will be
> NULL and regmap_del_irq_chip() will handle it correctly.
> 
> Your change adds some sense of precautions (the sec_pmic->irq_data may
> be set by some other module by mistake) but still it does not look like
> "needed" for Origen.

Indeed, I somehow assumed that regmap_del_irq_chip() doesn't check for
NULL 'struct regmap_irq_chip_data *d' argument.  Since such check is
actually present in regmap_del_irq_chip() the patch is not needed and
can be dropped.  Thanks for noticing this.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

