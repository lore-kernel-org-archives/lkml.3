Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3LMJcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:32:24 -0500
Received: from [207.46.163.212] ([207.46.163.212]:43214 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751802Ab3LMJcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:32:20 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Shawn Guo <Shawn.Guo@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        "Jingchang Lu" <jingchang.lu@freescale.com>
Subject: RE: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHO304NjulFCIkIhEyiDysSHbIEFZo7QgeAgBbF7cA=
Date: Fri, 13 Dec 2013 09:30:09 +0000
Message-ID: <e2fc53d0ff1d4a0a962500be6dc6e019@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir>
In-Reply-To: <20131128212510.GC14689@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(4396001)(85852003)(83072002)(81686001)(56816005)(87266001)(2656002)(69226001)(90146001)(74316001)(63696002)(80022001)(33646001)(85306002)(49866001)(47446002)(47976001)(56776001)(74502001)(87936001)(81816001)(66066001)(74876001)(83322001)(76786001)(81542001)(31966008)(81342001)(53806001)(47736001)(51856001)(74366001)(46102001)(65816001)(76576001)(74662001)(80976001)(76796001)(74706001)(77982001)(50986001)(76482001)(54356001)(79102001)(54316002)(59766001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB347;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +	struct fsl_pwm_chip *fpc;
> > +
> > +	fpc = to_fsl_chip(chip);
> > +
> > +	period_cycles = fsl_rate_to_cycles(fpc, period_ns);
> > +	if (period_cycles > 0xFFFF) {
> > +		dev_err(chip->dev, "required PWM period cycles(%lu) overflow "
> > +				"16-bits counter!\n", period_cycles);
> > +		return -EINVAL;
> > +	}
> > +
> > +	duty_cycles = fsl_rate_to_cycles(fpc, duty_ns);
> > +	if (duty_cycles >= 0xFFFF) {
> > +		dev_err(chip->dev, "required PWM duty cycles(%lu) overflow "
> > +				"16-bits counter!\n", duty_cycles);
> > +		return -EINVAL;
> > +	}
> 
> I'm not sure the error messages are all that useful. A -EINVAL error code
> should make it pretty clear what the problem is.
> 

Yes, it is.

But for the pwm leds, there hasn't any check about the return values, if
there is something wrong, we cannot get any information about this.

So I think this error messages are useful for this case.


--
Xiubo
