Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaIDCSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:18:33 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:18494
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751683AbaIDCSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:18:32 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
Thread-Topic: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
Thread-Index: AQHPwPGhd5+7l5+n2ECz3VCyJKPGDJvvSdwAgAEBCcA=
Date: Thu, 4 Sep 2014 02:18:28 +0000
Message-ID: <de8ef937785c45f582b444f2e3c1845e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031241310.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031241310.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199003)(24454002)(164054003)(189002)(90102001)(101416001)(21056001)(76482001)(76576001)(74502001)(77982001)(54356999)(99396002)(50986999)(46102001)(76176999)(31966008)(2656002)(4396001)(92566001)(19580395003)(19580405001)(86362001)(83322001)(74662001)(105586002)(74316001)(87936001)(83072002)(85852003)(64706001)(95666004)(99286002)(20776003)(85306004)(81342001)(106356001)(80022001)(66066001)(33646002)(77096002)(79102001)(110136001)(106116001)(108616004)(81542001)(107046002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB178;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
> calculation.
> 
> On Tue, 26 Aug 2014, Xiubo Li wrote:
> 
> > We should minus one after calculating the counter input clock's
> > prescaler.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> > ---
> >  drivers/clocksource/fsl_ftm_timer.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/fsl_ftm_timer.c
> b/drivers/clocksource/fsl_ftm_timer.c
> > index f70fcf2..974890e 100644
> > --- a/drivers/clocksource/fsl_ftm_timer.c
> > +++ b/drivers/clocksource/fsl_ftm_timer.c
> > @@ -311,7 +311,7 @@ static int __init ftm_calc_closest_round_cyc(unsigned
> long freq)
> >  						HZ * (1 << priv->ps++));
> >  	} while (priv->periodic_cyc > 0xFFFF);
> >
> > -	if (priv->ps > FTM_PS_MAX) {
> > +	if (--priv->ps > FTM_PS_MAX) {
> 
> Looking at this makes me run away screaming. Just because you
> increment priv->ps unconditionally in the loop above, you decrement it
> again here. Why not fix the calculation proper in the first place?
> 
>       for (cyc = ~0UL, ps = 0, div = HZ; cyc > 0xffff; ps++, div *= 2)
>       	       cyc = DIV_ROUND_CLOSEST(freq, div);
> 

Yes, this looks nice.

Thanks,

BRs
Xiubo


