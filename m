Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaJUMW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:22:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48327 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:22:55 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-47-5446501c4b67
Message-id: <1413894170.31665.9.camel@AMDC1943>
Subject: Re: [PATCH v2 1/4] regulator: max77686: Replace hard-coded opmode
 values with defines
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 21 Oct 2014 14:22:50 +0200
In-reply-to: <54464A37.6060701@collabora.co.uk>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
 <1413890597-31037-2-git-send-email-k.kozlowski@samsung.com>
 <54464A37.6060701@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xK7oyAW4hBo8nW1tsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdotvVzqYLDY9vsZqcXnXHDaLGef3MVnc
	vsxrsfbIXXYHPo+W5h42j7/Pr7N4/F31gtlj56y77B6bVnWyeWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGXsnHWQv+KBR8by/gbmBcY1CFyMHh4SAicTqn8ldjJxAppjEhXvr2boY
	uTiEBJYySmxftJEZJCEk8JlR4sSiIBCbV0Bf4sGLbjYQW1ggQaJr6VywGjYBY4nNy5eAxUUE
	7CRurH7IDDKIWeAns8SjtmMsIAkWAVWJe9NWghVxAg16snopO8S2VYwSfxuawCYxC6hLTJq3
	iBniOmWJxn43iMWCEj8m32OBKJGX2LzmLfMERoFZSDpmISmbhaRsASPzKkbR1NLkguKk9FxD
	veLE3OLSvHS95PzcTYyQGPqyg3HxMatDjAIcjEo8vBuWuYYIsSaWFVfmHmKU4GBWEuHNFXYL
	EeJNSaysSi3Kjy8qzUktPsTIxMEp1cC4+vpPadn3v1w+MDCyxR0s+jKVM3r/nbKtD95MUrU/
	0JGxc4cHi82Rl7G6z9+yrJ/edeTBjAPT5zklNuzcZ8vWNkX83TOTD9NPLMltXpWdosxfsJPV
	q1U+4Yj8t4U7f79zUlvfFfjkC6vVl3VL+GYtY5bZd2lBvbaN1hVrk2MTH9canJ7fxhmrocRS
	nJFoqMVcVJwIANWJAGR/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 13:57 +0200, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> Thanks a lot for the re-spin.
> 
> On 10/21/2014 01:23 PM, Krzysztof Kozlowski wrote:
> > Add defines for regulator operating modes which should be more readable,
> > especially if one does not have Maxim 77686 datasheet.
> > 
> > The patch does not introduce any functional change.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > ---
> >  drivers/regulator/max77686.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> > index ef1af2debbd2..cffe0c69d57d 100644
> > --- a/drivers/regulator/max77686.c
> > +++ b/drivers/regulator/max77686.c
> > @@ -45,6 +45,16 @@
> >  #define MAX77686_DVS_MINUV	600000
> >  #define MAX77686_DVS_UVSTEP	12500
> >  
> > +/* On/off controlled by PWRREQ */
> > +#define MAX77686_OPMODE_OFF_PWRREQ	0x1
> 
> Minor nit: maybe this should be called MAX77802_OFF_PWRREQ (without the OPMODE)?
> Since afaiu from a conceptual pov the regulators only supports two modes: normal
> and low power mode.
> 
> If a regulator is disabled or put in low power mode by PWRREQ on suspend, then
> is not really an operating mode (the regulator output will still be normal until
> suspend) but an enable pin to switch a regulator mode automatically by the SoC.

No problem. This is just a define for value used in register. However
OPMODE is used in other places in that driver:
#define MAX77686_OPMODE_SHIFT   6
#define MAX77686_OPMODE_BUCK234_SHIFT   4
#define MAX77686_OPMODE_MASK    0x3

So this would be a little inconsistent...

> 
> > +/*
> > + * For some regulators this means:
> > + *  - forcing low power mode.
> > + *  - low power mode controlled by PWRREQ.
> > + */
> > +#define MAX77686_OPMODE_LOWPOWER	0x2
> 
> Can you also add a #define MAX77686_LP_PWRREQ 0x2 and use each one when
> appropriate? That will better document when 0x2 means low power by PWRREQ
> and when it means change regulator mode to low power.

Actually I made mistake in that comment. The 0x2 means force low power
mode only for buck1-4... but there is no set_suspend_mode for these
bucks. So this #define has only one semantic value.

> Also, are you sure that forcing low power mode is 0x2 and not 0x1?

You're right, for other LDOs, low power mode may be forced with 0x1. For
such regulators the max77686_set_suspend_mode() is used which does not
set value 0x1. This means that each define has only one semantic
meaning.

I'll re-spin and fix the documentation to reflect both device
capabilities and how the driver currently works.

Thanks for pointing this.

> 
> I'm asking because I see in the max77802 data-sheet that regulators that
> supports its mode to be low power during runtime are using 0x1:
> 
> 01b: Output ON in Low Power Mode
> 
> Maybe is different in the max77686 or I misunderstood your comment though...
> 
> > +#define MAX77686_OPMODE_NORMAL		0x3
> > +
> >  #define MAX77686_OPMODE_SHIFT	6
> >  #define MAX77686_OPMODE_BUCK234_SHIFT	4
> >  #define MAX77686_OPMODE_MASK	0x3
> > @@ -76,9 +86,10 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
> >  	int ret, id = rdev_get_id(rdev);
> >  
> >  	if (id == MAX77686_BUCK1)
> > -		val = 0x1;
> > +		val = MAX77686_OPMODE_OFF_PWRREQ;
> >  	else
> > -		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
> > +		val = MAX77686_OPMODE_OFF_PWRREQ
> > +			<< MAX77686_OPMODE_BUCK234_SHIFT;
> >  
> >  	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> >  				 rdev->desc->enable_mask, val);
> > @@ -103,10 +114,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
> >  
> >  	switch (mode) {
> >  	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
> > -		val = 0x2 << MAX77686_OPMODE_SHIFT;
> > +		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
> >  		break;
> >  	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
> > -		val = 0x3 << MAX77686_OPMODE_SHIFT;
> > +		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
> >  		break;
> >  	default:
> >  		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
> > @@ -133,13 +144,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
> >  
> >  	switch (mode) {
> >  	case REGULATOR_MODE_STANDBY:			/* switch off */
> > -		val = 0x1 << MAX77686_OPMODE_SHIFT;
> > +		val = MAX77686_OPMODE_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
> >  		break;
> >  	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
> > -		val = 0x2 << MAX77686_OPMODE_SHIFT;
> > +		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
> >  		break;
> >  	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
> > -		val = 0x3 << MAX77686_OPMODE_SHIFT;
> > +		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
> >  		break;
> >  	default:
> >  		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
> > 
> 
> If you do those two changes please feel free to add my Reviewed-by.
> 
> Best regards,
> Javier

