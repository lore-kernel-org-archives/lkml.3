Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3LRPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:51:52 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:32827 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755142Ab3LRPvu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:51:50 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 10:51:49 EST
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-9.tower-180.messagelabs.com!1387381533!28270216!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Jean Delvare <khali@linux-fr.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>
Subject: RE: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052  power driver
Thread-Topic: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052  power driver
Thread-Index: AQHO/AZpFQ5cD64o6Uubym1FfuDMzJpaFb4w
Date: Wed, 18 Dec 2013 15:45:32 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
 <20131218163234.714a166c@endymion.delvare>
In-Reply-To: <20131218163234.714a166c@endymion.delvare>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: 18 December 2013 15:33
> To: Opensource [Anthony Olech]
> Cc: Anton Vorontsov; David Woodhouse; David Dajun Chen; open list; open
> list:HARDWARE MONITORING
> Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
> power driver
> On Wed, 18 Dec 2013 15:21:13 +0000, Anthony Olech wrote:
> > The ADC resolution of the PMIC is 10-bits, this means that the maximum
> > possible value is 1023 and not the 1024 as in the code.
> The conversion from register value to mV depends on the ADC's LSB, not its
> range. So the maximum value which can be represented is irrelevant.

thanks for the speedy response, but the converted value returned by the function
does depend on the scaling.

For example take the two cases where value in 0x1F0, then the erroneous previous
calculation yields 3469 and the new corrected calculation yields 3470

So please apply the patch as it truly fixes an error.

many thanks

Tony Olech

> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > ---
> > This patch is relative to linux-next repository tag next-20131218
> >  drivers/power/da9052-battery.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > diff --git a/drivers/power/da9052-battery.c
> > b/drivers/power/da9052-battery.c index f8f4c0f..8f0f259 100644
> > --- a/drivers/power/da9052-battery.c
> > +++ b/drivers/power/da9052-battery.c
> > @@ -178,7 +178,7 @@ struct da9052_battery {
> >  static inline int volt_reg_to_mV(int value)  {
> > -	return ((value * 1000) / 512) + 2500;
> > +	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
> >  }
> >  static inline int ichg_reg_to_mA(int value)
> --
> Jean Delvare
