Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaAHE6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:58:53 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:37240
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbaAHE6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:58:47 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
Thread-Topic: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
Thread-Index: AQHPC3Y26AB4e4+Onk2boSRX8NyFipp45miAgAFeYYA=
Date: Wed, 8 Jan 2014 04:58:31 +0000
Message-ID: <1af212b11abb47b9bf97dea7329f1151@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389074700-1825-1-git-send-email-Li.Xiubo@freescale.com>
 <20140107080127.GD20074@core.coreip.homeip.net>
In-Reply-To: <20140107080127.GD20074@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(199002)(51704005)(66066001)(74706001)(74876001)(77982001)(63696002)(79102001)(59766001)(81816001)(81686001)(65816001)(80022001)(76796001)(76786001)(76576001)(56776001)(85306002)(87266001)(56816005)(90146001)(83072002)(85852003)(87936001)(2656002)(80976001)(83322001)(74316001)(74366001)(53806001)(76482001)(54356001)(4396001)(46102001)(51856001)(49866001)(47736001)(50986001)(47976001)(74502001)(47446002)(31966008)(54316002)(74662001)(81542001)(69226001)(81342001)(33646001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >  drivers/pwm/core.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> > index 2ca9504..74c9f9a 100644
> > --- a/drivers/pwm/core.c
> > +++ b/drivers/pwm/core.c
> > @@ -80,7 +80,6 @@ static void free_pwms(struct pwm_chip *chip)
> >
> >  	bitmap_clear(allocated_pwms, chip->base, chip->npwm);
> >
> > -	kfree(chip->pwms);
> >  	chip->pwms = NULL;
> >  }
> >
> > @@ -245,7 +244,9 @@ int pwmchip_add(struct pwm_chip *chip)
> >  	if (ret < 0)
> >  		goto out;
> >
> > -	chip->pwms = kzalloc(chip->npwm * sizeof(*pwm), GFP_KERNEL);
> > +	chip->pwms = devm_kzalloc(chip->dev,
> > +				  chip->npwm * sizeof(*pwm),
> > +				  GFP_KERNEL);
> >  	if (!chip->pwms) {
> >  		ret = -ENOMEM;
> >  		goto out;
> 
> Is it guaranteed that pwmchip_add()/free_pwms() will only be called in
> probe() and remove() paths? It is probably safe assumption, but maybe it
> should be mentioned in comments now that we definitely have this
> restricion.
>

Yes, for now they are.
 
Thanks.

--
Best Regards,
Xiubo
