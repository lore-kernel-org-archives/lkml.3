Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaJVJQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:16:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32271 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaJVJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:16:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-c3-544775e01012
Content-transfer-encoding: 8BIT
Message-id: <1413969375.32084.3.camel@AMDC1943>
Subject: Re: [PATCH RESEND 2/3] extcon: max77693: Request only specific
 interrupts
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 22 Oct 2014 11:16:15 +0200
In-reply-to: <5447730E.80500@samsung.com>
References: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
 <1413967540-27626-2-git-send-email-k.kozlowski@samsung.com>
 <5447730E.80500@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7oPSt1DDCbuN7bYOGM9q8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CzWHrnLbnG7cQWbxeluVgcOjzvX9rB5zDsZ6NG3ZRWjx+dNcgEs
	UVw2Kak5mWWpRfp2CVwZ91euYit4JFexaP1L9gbGDxJdjJwcEgImEmtenmGBsMUkLtxbz9bF
	yMUhJLCUUeJn2y5WkASvgKDEj8n3gIo4OJgF5CWOXMoGCTMLqEtMmreIGaL+M6NE/6ynbBD1
	+hLn389mB7GFBUIkuts/gsXZBIwlNi9fAmaLCGhIzPx7hRGkmVlgOZPEw1fzmEESLAKqErtP
	zmYEsTkFNCXWL1rIBLFhCaPE143XGUGukBBQlmjsd5vAKDALyX2zEO6bheS+BYzMqxhFU0uT
	C4qT0nMN9YoTc4tL89L1kvNzNzFCAvzLDsbFx6wOMQpwMCrx8M7gcA8RYk0sK67MPcQowcGs
	JMJ7Lx0oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTFMfvIdkY8hkwo/3/zlFLNS8tuU0mLOO9sc
	7c70zj3wb3soV91W80sxc52vLtwe9Tn9nqFEZo7ABfY70xSP20R8uhg1Sev/lwcT3tpdP9C0
	1FXz5iv3e9nrHPqu5F+36cm5qFKtyZF2/tLFs56LLLyCJ/XFxJ42Vupnf72i/YTRjc2n+lb8
	3WipxFKckWioxVxUnAgATsL/RU4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-22 at 18:04 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> The extcon-max77693.c was tested by all cables (mhl, hdmi, usb, usb-host, dock for audio play, dock for mhl).
> with default_init_data register setting. If you deletes legacy default_init_data[] register setting,
> extcon-max77693.c can not guarantee the operation of upper cables.
> 
> So, I want to maintain 'default_init_data' register setting value.

I understand. Is this driver used anywhere without DTS? Because the
difference will be only in non-DTS board.

With DTS the driver receives the same interrupts (before/after patch).

However I do not insist on this patch. It is merely a cleanup.

Best regards,
Krzysztof

> 
> Thanks,
> Chanwoo Choi
> 
> On 10/22/2014 05:45 PM, Krzysztof Kozlowski wrote:
> > The driver was requesting all MUIC interrupts but then was masking most
> > of them manually at end of probe (with default_init_data). Since
> > default_init_data cannot be passed through DTS (no bindings for driver),
> > this was a conflicting behavior. First get everything, then mask what we
> > don't want.
> > 
> > This could change after adding DTS bindings for requesting specific
> > MUIC interrupts. Until then driver should request only these MUIC
> > interrupts which he is really interested in.
> > 
> > The commit does not introduce any functional change when the driver is
> > used with DTS (no platform data). However this changes the behavior with
> > platform data supplied. In such case the driver will request only 3
> > interrupts (ADC, ADC1K, ChgTyp). Platform data could still unmask other
> > interrupts but they won't be handled by the driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/extcon/extcon-max77693.c | 26 --------------------------
> >  1 file changed, 26 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> > index 863d088c9bdd..9d21e75a7032 100644
> > --- a/drivers/extcon/extcon-max77693.c
> > +++ b/drivers/extcon/extcon-max77693.c
> > @@ -44,19 +44,6 @@ static struct max77693_reg_data default_init_data[] = {
> >  		.addr = MAX77693_MUIC_REG_STATUS2,
> >  		.data = STATUS2_CHGDETRUN_MASK,
> >  	}, {
> > -		/* INTMASK1 - Unmask [3]ADC1KM,[0]ADCM */
> > -		.addr = MAX77693_MUIC_REG_INTMASK1,
> > -		.data = INTMASK1_ADC1K_MASK
> > -			| INTMASK1_ADC_MASK,
> > -	}, {
> > -		/* INTMASK2 - Unmask [0]ChgTypM */
> > -		.addr = MAX77693_MUIC_REG_INTMASK2,
> > -		.data = INTMASK2_CHGTYP_MASK,
> > -	}, {
> > -		/* INTMASK3 - Mask all of interrupts */
> > -		.addr = MAX77693_MUIC_REG_INTMASK3,
> > -		.data = 0x0,
> > -	}, {
> >  		/* CDETCTRL2 */
> >  		.addr = MAX77693_MUIC_REG_CDETCTRL2,
> >  		.data = CDETCTRL2_VIDRMEN_MASK
> > @@ -135,21 +122,8 @@ struct max77693_muic_irq {
> >  
> >  static struct max77693_muic_irq muic_irqs[] = {
> >  	{ MAX77693_MUIC_IRQ_INT1_ADC,		"muic-ADC" },
> > -	{ MAX77693_MUIC_IRQ_INT1_ADC_LOW,	"muic-ADCLOW" },
> > -	{ MAX77693_MUIC_IRQ_INT1_ADC_ERR,	"muic-ADCError" },
> >  	{ MAX77693_MUIC_IRQ_INT1_ADC1K,		"muic-ADC1K" },
> >  	{ MAX77693_MUIC_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
> > -	{ MAX77693_MUIC_IRQ_INT2_CHGDETREUN,	"muic-CHGDETREUN" },
> > -	{ MAX77693_MUIC_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
> > -	{ MAX77693_MUIC_IRQ_INT2_DXOVP,		"muic-DXOVP" },
> > -	{ MAX77693_MUIC_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
> > -	{ MAX77693_MUIC_IRQ_INT2_VIDRM,		"muic-VIDRM" },
> > -	{ MAX77693_MUIC_IRQ_INT3_EOC,		"muic-EOC" },
> > -	{ MAX77693_MUIC_IRQ_INT3_CGMBC,		"muic-CGMBC" },
> > -	{ MAX77693_MUIC_IRQ_INT3_OVP,		"muic-OVP" },
> > -	{ MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,	"muic-MBCCHG_ERR" },
> > -	{ MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,	"muic-CHG_ENABLED" },
> > -	{ MAX77693_MUIC_IRQ_INT3_BAT_DET,	"muic-BAT_DET" },
> >  };
> >  
> >  /* Define supported accessory type */
> > 

