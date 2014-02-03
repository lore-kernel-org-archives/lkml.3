Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaBCQNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:13:44 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.166]:44391 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbaBCQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:13:43 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-8.tower-38.messagelabs.com!1391443891!14670583!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
Subject: RE: [PATCH V1] fix da9052 volatile register definition ommissions
Thread-Topic: [PATCH V1] fix da9052 volatile register definition ommissions
Thread-Index: AQHPHE23tMPX7aURykWvLFze4y5OupqjXPuAgABedmA=
Date: Mon, 3 Feb 2014 16:11:30 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51AD22E658@NB-EX-MBX02.diasemi.com>
References: <201401281723.s0SHNmLa041140@swsrvapps-02.lan>
 <20140203102919.GP13529@lee--X1>
In-Reply-To: <20140203102919.GP13529@lee--X1>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s13GDmcN012206

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: 03 February 2014 10:29
> To: Opensource [Anthony Olech]
> Cc: Mark Brown; Samuel Ortiz; linux-kernel@vger.kernel.org; David Dajun
> Chen
> Subject: Re: [PATCH V1] fix da9052 volatile register definition ommissions
> > Three of the PMIC registers have some bits that are changed
> > autonomously by the PMIC itself (some time) after being set by some
> > component driver of the DA9052 PMIC and hence they need to be marked
> > as volatile so that the regmap API will not cache their values.
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> These are not correct.
> Who authored the patch?

Hi Lee,

I found the problem when running regression tests for another different problem.
And according to my testing on a SMDK6410+DA9053EVB the patch is correct!!

Tony Olech

> > ---
> > This patch is relative to linux-next repository tag next-20140128
> > The bug that this patch fixes affects two components of DA9052 namely:
> > WATCHDOG - the first kick will work but sebsequent ones will not
> >            thus the will timeout at 2 x interval.
> > REGULATORS - the first change to any DA9052 BUCK voltage will be
> >              actioned, but sebsequent ones will not.
> Which patch caused the bug?

I will find out when I start rebasing backwards to submit patches to linux-stable!

> >  drivers/mfd/da9052-core.c |    3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
> > index 25838f1..e8af816 100644
> > --- a/drivers/mfd/da9052-core.c
> > +++ b/drivers/mfd/da9052-core.c
> > @@ -279,6 +279,9 @@ static bool da9052_reg_volatile(struct device *dev,
> unsigned int reg)
> >  	case DA9052_EVENT_B_REG:
> >  	case DA9052_EVENT_C_REG:
> >  	case DA9052_EVENT_D_REG:
> > +	case DA9052_CONTROL_B_REG:
> > +	case DA9052_CONTROL_D_REG:
> > +	case DA9052_SUPPLY_REG:
> >  	case DA9052_FAULTLOG_REG:
> >  	case DA9052_CHG_TIME_REG:
> >  	case DA9052_ADC_RES_L_REG:
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead Linaro.org â”‚ Open source
> software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
