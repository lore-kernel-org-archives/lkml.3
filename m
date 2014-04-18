Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaDRH7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:59:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64190 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaDRH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:24 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-5c-5350db58afe2
Message-id: <1397807962.29800.10.camel@AMDC1943>
Subject: Re: [PATCH 2/2] mfd: sec-core: Update sec_pmic documentation
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 18 Apr 2014 09:59:22 +0200
In-reply-to: <20140417083258.GH28725@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
 <1397477015-13900-2-git-send-email-k.kozlowski@samsung.com>
 <20140417083258.GH28725@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xq7qRtwOCDZbIWWycsZ7V4mzTG3aL
	+1+PMlpc3jWHzWLtkbvsFqe7WS0urvjC5MDucefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUn
	syy1SN8ugStj47ZnTAXHxCu6Lh1ibmCcIdTFyMkhIWAi8e3PN3YIW0ziwr31bF2MXBxCAksZ
	JQ6teAnlfGaUmPfmEytIFa+AgcTB60uYQGxhAVeJGZeegdlsAsYSm5cvAWrg4BARUJE498Yc
	pJdZ4B+jxJKJZ5lBalgEVCVm3W4BszkFdCU6T69lhViwglHiw7alYIOYBdQlJs1bxAxxkpLE
	uXVrGCEWC0r8mHyPBaJGXmLzmrfMExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OL
	S/PS9ZLzczcxQgL76w7GpcesDjEKcDAq8fBe+OofLMSaWFZcmXuIUYKDWUmEV7k0IFiINyWx
	siq1KD++qDQntfgQIxMHp1QD444q+W0t188ZVekI7l63RF5k4jnRsBvKuZmv2iUmSd9qPX3t
	7vejiRkRG6omSj/LYnmmUWjD6N5pUl3y2uv0I7szU7cmFs3TD6vpDa3dtvahJRu31cNHXMFp
	up4zI5fsOv937dXCCZcvyD0TXi5uc7/y3d7pU25sfWj4ZO5m0Wfq86/v9OT6uVyJpTgj0VCL
	uag4EQB84fSKSgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-04-17 at 09:32 +0100, Lee Jones wrote:
> > Update the documentation for sec_pmic state container structure to
> > reflect current code.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  include/linux/mfd/samsung/core.h | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> > index 2633083262ea..1923fe026c01 100644
> > --- a/include/linux/mfd/samsung/core.h
> > +++ b/include/linux/mfd/samsung/core.h
> > @@ -24,18 +24,23 @@ enum sec_device_type {
> >  };
> >  
> >  /**
> > - * struct sec_pmic_dev - s5m87xx master device for sub-drivers
> > - * @dev: master device of the chip (can be used to access platform data)
> > - * @pdata: pointer to private data used to pass platform data to child
> > - * @i2c: i2c client private data for regulator
> > - * @iolock: mutex for serializing io access
> > - * @irqlock: mutex for buslock
> > - * @irq_base: base IRQ number for sec-pmic, required for IRQs
> > - * @irq: generic IRQ number for s5m87xx
> > - * @ono: power onoff IRQ number for s5m87xx
> > - * @irq_masks_cur: currently active value
> > - * @irq_masks_cache: cached hardware value
> > - * @type: indicate which s5m87xx "variant" is used
> > + * struct sec_pmic_dev - s2m/s5m master device for sub-drivers
> > + * @dev:		Master device of the chip (can be used to access
> > + *			platform data)
> 
> Please remove the part in ()'s.

OK

> 
> a) There's no need for it - we know what's in 'struct device' and b)
> if 'struct platform_data' is removed from 'struct device' this comment
> will become incorrect. Easy maintainability and all that ...
> 
> > + * @pdata:		Platform data from DTS or board files
> 
> s/from/populated with data from

OK

> 
> > + * @regmap_pmic:	Regmap associated with PMIC's I2C address
> > + * @i2c:		I2C client of the main driver
> > + * @device_type:	Type of device, matches enum sec_device_type
> > + * @irq_base:		Base IRQ number for device, required for IRQs
> 
> Is there any reason for not using IRQ Domains?

No, I have it in my TODO list.

> 
> > + * @irq:		Generic IRQ number for device
> > + * @irq_data:		Runtime data structure for IRQ controller
> > + * @ono:		Power onoff IRQ number for s5m87xx
> 
> Perhaps consider a better name for this in a future patch.

Actually I couldn't find usage of it so I plan to do some cleanup and
get rid of it.

Thanks for review.

Best regards,
Krzysztof

> 
> > + * @wakeup:		Whether or not this is a wakeup device
> > + * @wtsr_smpl:		Whether or not to enable in RTC driver the Watchdog
> > + *			Timer Software Reset (registers set to default value
> > + *			after PWRHOLD falling) and Sudden Momentary Power Loss
> > + *			(PMIC will enter power on sequence after short drop in
> > + *			VBATT voltage).
> >   */
> >  struct sec_pmic_dev {
> >  	struct device *dev;
> 

