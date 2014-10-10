Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaJJKIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:08:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12440 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaJJKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:08:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-89-5437b00429e9
Content-transfer-encoding: 8BIT
Message-id: <1412935683.4143.3.camel@AMDC1943>
Subject: Re: [PATCH fixes 2/2] extcon: max77693: Fix always masked MUIC
 interrupts
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Fri, 10 Oct 2014 12:08:03 +0200
In-reply-to: <20141010094851.GJ26795@lee--X1>
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
 <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
 <20141010085854.GC26795@lee--X1> <1412931716.22108.0.camel@AMDC1943>
 <20141010094851.GJ26795@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7osG8xDDF5MsbDYOGM9q8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CzWHrnLbnG7cQWbxeluVosFGx8xOnB63Lm2h81j3slAj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4++I1e8Ed2YrWNdfZGhifinUxcnJICJhILJ77lgXCFpO4
	cG89WxcjF4eQwFJGiU9f9jKCJHgFBCV+TL4HVMTBwSwgL3HkUjZImFlAXWLSvEXMEPWfGSUm
	vtoNVa8n8b69CWyosECIxN03P8HibALGEpuXL2EDmSMioCJx7o05SC+zwGEmidOb3zGB1LAI
	qEqsevkfrJdTQFfiw7Gj7BAL3jNKPDv4F6xZQkBZorHfbQKjwCwk581COG8WkvMWMDKvYhRN
	LU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ9C87GBcfszrEKMDBqMTDe0HGPESINbGsuDL3EKME
	B7OSCG/3HKAQb0piZVVqUX58UWlOavEhRiYOTqkGxjV1orNC1L/1v/ey/VZjU5DsMnPOdElx
	uctPamdt/v9+3spbqt95nH/1By65t+pa5tzGCSoeidMU9WUe7+rduu6X650NmREfopa/Xr71
	TEBWWtzisBMvBS7ftn8rkFe/5mTmhCV3l3g4vRE8OXEFx7WFEXynIt/5hjbFTOOzndxgtYL3
	I8ujt0JKLMUZiYZazEXFiQC+SazCUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-10 at 10:48 +0100, Lee Jones wrote:
> On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > On pią, 2014-10-10 at 09:58 +0100, Lee Jones wrote:
> > > On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:
> > > 
> > > > All interrupts coming from MUIC were ignored because interrupt source
> > > > register was masked.
> > > > 
> > > > The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> > > > which give information about PMIC block triggering the individual
> > > > interrupt (charger, topsys, MUIC, flash LED).
> > > > 
> > > > By default bootloader could initialize this register to "mask all"
> > > > value. In such case (observed on Trats2 board) MUIC interrupts won't be
> > > > generated regardless of their mask status. Regmap irq chip was unmasking
> > > > individual MUIC interrupts but the source was masked
> > > > 
> > > > Before introducing regmap irq chip this interrupt source was unmasked,
> > > > read and acked. Reading and acking is not necessary but unmasking is. Do
> > > > it in extcon driver.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> > > > ---
> > > >  drivers/extcon/extcon-max77693.c     | 16 ++++++++++++++++
> > > >  include/linux/mfd/max77693-private.h |  5 +++++
> > > >  2 files changed, 21 insertions(+)
> > > 
> > > Did you run this through checkpatch?
> > 
> > Yes, no complains.
> 
> Run it again!  One of those lines is clearly over 80 chars.

>From the checkpatch still nothing. Really! :)

I believe you're mentioning the line:
dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",

Probably checkpatch does not complain about it because it is the string
who dares to exceed 80 chars. I can split this into:

dev_err(&pdev->dev,
	"Could not unmask MUIC interrupt in INTSRC: %d\n",
	ret);

Best regards,
Krzysztof

> 
> > > > diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> > > > index 490e27475bac..d3adacf3187f 100644
> > > > --- a/drivers/extcon/extcon-max77693.c
> > > > +++ b/drivers/extcon/extcon-max77693.c
> > > > @@ -1176,6 +1176,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
> > > >  		}
> > > >  	}
> > > >  
> > > > +	if (i) {
> > > > +		/*
> > > > +		 * i>0, at least one MUIC interrupt requested so need to unmask
> > > > +		 * MUIC interrupt in INTSRC register. Without that MUIC
> > > > +		 * interrupts will not be reported.
> > > > +		 */
> > > > +		ret = regmap_update_bits(max77693->regmap,
> > > > +				MAX77693_PMIC_REG_INTSRC_MASK, SRC_IRQ_MUIC,
> > > > +				~SRC_IRQ_MUIC);
> > > > +		if (ret < 0) {
> > > > +			dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",
> > > > +					ret);
> > > > +			return ret;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	/* Initialize extcon device */
> > > >  	info->edev = devm_extcon_dev_allocate(&pdev->dev,
> > > >  					      max77693_extcon_cable);
> > > > diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> > > > index e1b2b61285b9..4f1a80b66ecf 100644
> > > > --- a/include/linux/mfd/max77693-private.h
> > > > +++ b/include/linux/mfd/max77693-private.h
> > > > @@ -438,6 +438,11 @@ enum max77693_irq_source {
> > > >  	MAX77693_IRQ_GROUP_NR,
> > > >  };
> > > >  
> > > > +#define SRC_IRQ_CHARGER			BIT(0)
> > > > +#define SRC_IRQ_TOP			BIT(1)
> > > > +#define SRC_IRQ_FLASH			BIT(2)
> > > > +#define SRC_IRQ_MUIC			BIT(3)
> > > > +
> > > >  #define LED_IRQ_FLED2_OPEN		BIT(0)
> > > >  #define LED_IRQ_FLED2_SHORT		BIT(1)
> > > >  #define LED_IRQ_FLED1_OPEN		BIT(2)
> > > 
> > 
> 

