Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbaJVJ3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:29:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12655 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaJVJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:28:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-6e-544778cc77a6
Content-transfer-encoding: 8BIT
Message-id: <1413970123.2504.2.camel@AMDC1943>
Subject: Re: [PATCH fixes v2] mfd: max77693: Fix always masked MUIC interrupts
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Wed, 22 Oct 2014 11:28:43 +0200
In-reply-to: <20141010105600.GL26795@lee--X1>
References: <1412938115-11606-1-git-send-email-k.kozlowski@samsung.com>
 <20141010105600.GL26795@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xy7pnKtxDDG6eMLfYOGM9q8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CzWHrnLbnG7cQWbxeluVosFGx8xOnB63Lm2h81j3slAj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4Mr4/morY8FZ6Yrj39qYGxgbxLoYOTkkBEwkZv6ZxAxhi0lc
	uLeerYuRi0NIYCmjxKI5c8ESvAKCEj8m32PpYuTgYBaQlzhyKRskzCygLjFp3iKwEiGBz4wS
	T44YQpTrSXzr3swCYgsL+EnsffCYCcRmEzCW2Lx8CRvIGBEBFYlzb8xBVjELHGaSOL35HRNI
	nEVAVWLXaT6Qck4BXYn9r59Cjc+SuHLxPjtIiYSAskRjv9sERoFZSG6bhXDbLCS3LWBkXsUo
	mlqaXFCclJ5rqFecmFtcmpeul5yfu4kREuJfdjAuPmZ1iFGAg1GJh3cGh3uIEGtiWXFl7iFG
	CQ5mJRFet1KgEG9KYmVValF+fFFpTmrxIUYmDk6pBsYlV05V3v7Tf2NLQ33JhJl/Fszxvvrg
	9s767eksautNauqVHuzPnflxz/1vjh+yX1980ajAc0DA+EbC69dVTp7a7P/Y/F+eCHAzdcxQ
	Oxj0eUKL7VwGoYn9lfK72qIemTZ2ZV6b9aQz9vnabq8X04tZpH0MhT7NnDFpnr7i3NxrL168
	4fvz+MQpJZbijERDLeai4kQAu7+U3U8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-10 at 11:56 +0100, Lee Jones wrote:
> On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > All interrupts coming from MUIC were ignored because interrupt source
> > register was masked.
> > 
> > The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> > which give information about PMIC block triggering the individual
> > interrupt (charger, topsys, MUIC, flash LED).
> > 
> > By default bootloader could initialize this register to "mask all"
> > value. In such case (observed on Trats2 board) MUIC interrupts won't be
> > generated regardless of their mask status. Regmap irq chip was unmasking
> > individual MUIC interrupts but the source was masked
> > 
> > Before introducing regmap irq chip this interrupt source was unmasked,
> > read and acked. Reading and acking is not necessary but unmasking is.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> 
> Applied to -fixes until someone complains.

Hi Lee,

I cannot find this patch on gitweb (MFD tree), have you applied it?

If not then could you squash it with:
mfd: max77693: Fix a truncate warning
https://lkml.org/lkml/2014/10/14/161

If you wish I could resend it.

Best regards,
Krzysztof

> 
> > ---
> > 
> > Changes since v1:
> > 1. Do the unmasking in main MFD driver. Additionally unmask all
> >    interrupts, not only MUIC. Suggested by Chanwoo Choi.
> > ---
> >  drivers/mfd/max77693.c               | 12 ++++++++++++
> >  include/linux/mfd/max77693-private.h |  7 +++++++
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > index 4b54da1ff7ab..4e4e6a1a6301 100644
> > --- a/drivers/mfd/max77693.c
> > +++ b/drivers/mfd/max77693.c
> > @@ -253,6 +253,17 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
> >  		goto err_irq_muic;
> >  	}
> >  
> > +	/* Unmask interrupts from all blocks in interrupt source register */
> > +	ret = regmap_update_bits(max77693->regmap,
> > +				MAX77693_PMIC_REG_INTSRC_MASK,
> > +				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
> > +	if (ret < 0) {
> > +		dev_err(max77693->dev,
> > +			"Could not unmask interrupts in INTSRC: %d\n",
> > +			ret);
> > +		goto err_intsrc;
> > +	}
> > +
> >  	pm_runtime_set_active(max77693->dev);
> >  
> >  	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
> > @@ -264,6 +275,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
> >  
> >  err_mfd:
> >  	mfd_remove_devices(max77693->dev);
> > +err_intsrc:
> >  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
> >  err_irq_muic:
> >  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
> > diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> > index e1b2b61285b9..15fed5365a20 100644
> > --- a/include/linux/mfd/max77693-private.h
> > +++ b/include/linux/mfd/max77693-private.h
> > @@ -438,6 +438,13 @@ enum max77693_irq_source {
> >  	MAX77693_IRQ_GROUP_NR,
> >  };
> >  
> > +#define SRC_IRQ_CHARGER			BIT(0)
> > +#define SRC_IRQ_TOP			BIT(1)
> > +#define SRC_IRQ_FLASH			BIT(2)
> > +#define SRC_IRQ_MUIC			BIT(3)
> > +#define SRC_IRQ_ALL			(SRC_IRQ_CHARGER | SRC_IRQ_TOP \
> > +						| SRC_IRQ_FLASH | SRC_IRQ_MUIC)
> > +
> >  #define LED_IRQ_FLED2_OPEN		BIT(0)
> >  #define LED_IRQ_FLED2_SHORT		BIT(1)
> >  #define LED_IRQ_FLED1_OPEN		BIT(2)
> 

