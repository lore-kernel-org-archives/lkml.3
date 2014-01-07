Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaAGHgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 02:36:18 -0500
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:17873
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754056AbaAGHgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 02:36:16 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Joe Perches <joe@perches.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
Thread-Topic: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
Thread-Index: AQHPC3Y26AB4e4+Onk2boSRX8NyFipp42UoAgAAF0YA=
Date: Tue, 7 Jan 2014 07:36:14 +0000
Message-ID: <20a8a6494bfd4a7e8367e53b13c7b3b2@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1389074700-1825-1-git-send-email-Li.Xiubo@freescale.com>
 <1389078870.32137.5.camel@joe-AO722>
In-Reply-To: <1389078870.32137.5.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(189002)(199002)(85852003)(83072002)(56816005)(81542001)(90146001)(74662001)(31966008)(76786001)(76796001)(76576001)(81342001)(69226001)(47446002)(74502001)(54316002)(63696002)(65816001)(66066001)(80022001)(53806001)(54356001)(46102001)(51856001)(76482001)(59766001)(77982001)(79102001)(47976001)(50986001)(56776001)(47736001)(4396001)(49866001)(74706001)(83322001)(33646001)(74876001)(85306002)(74366001)(74316001)(81686001)(2656002)(81816001)(80976001)(87936001)(87266001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB512;H:DM2PR03MB509.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Use devm_kzalloc instead of kzalloc to free automatically and make
> > the cleanup paths simpler and the code slightly shorter.
> []
> > diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> []
> > @@ -245,7 +244,9 @@ int pwmchip_add(struct pwm_chip *chip)
> >  	if (ret < 0)
> >  		goto out;
> >
> > -	chip->pwms = kzalloc(chip->npwm * sizeof(*pwm), GFP_KERNEL);
> > +	chip->pwms = devm_kzalloc(chip->dev,
> > +				  chip->npwm * sizeof(*pwm),
> > +				  GFP_KERNEL);
> 
> There is a devm_kcalloc and this should likely use it.
> 

Yes, I will use it.

Thanks,

 

