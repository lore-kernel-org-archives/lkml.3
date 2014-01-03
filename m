Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaACJQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:16:13 -0500
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:49666
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaACJQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:16:10 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "bpringlemeir@nbsps.com" <bpringlemeir@nbsps.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHPCEvHgiIG4cfLhk+jSAVclg4YcZpynt6AgAAUaXA=
Date: Fri, 3 Jan 2014 09:16:06 +0000
Message-ID: <f9527d65aa234f40af2830d9fb139bbb@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388726661-3391-1-git-send-email-Li.Xiubo@freescale.com>
 <20140103074511.GA10680@core.coreip.homeip.net>
In-Reply-To: <20140103074511.GA10680@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(51704005)(189002)(24454002)(69226001)(77982001)(83322001)(56816005)(90146001)(85852003)(74316001)(81342001)(81542001)(74502001)(31966008)(83072002)(76786001)(76576001)(74366001)(51856001)(81816001)(74662001)(79102001)(63696002)(87266001)(47446002)(85306002)(49866001)(54316002)(47736001)(4396001)(50986001)(81686001)(2656002)(74876001)(74706001)(47976001)(33646001)(76482001)(53806001)(80022001)(46102001)(59766001)(76796001)(80976001)(65816001)(54356001)(56776001)(87936001)(66066001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB224;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> Subject: Re: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
> 
> Hi Xiubo,
> 
> On Fri, Jan 03, 2014 at 01:24:21PM +0800, Xiubo Li wrote:
> > +
> > +static inline int fsl_pwm_calculate_default_ps(struct fsl_pwm_chip *fpc,
> > +					       enum fsl_pwm_clk index)
> > +{
> 
> Why do you declare this (and other module-local) function as inline?
> It is usually better let compiler decide if given function should be
> inlined or not.
> 

Could the compiler know when the given function should be inlined by not declare it?
And when will be inlined ?

> [...]
> 
> > +
> > +static int fsl_pwm_remove(struct platform_device *pdev)
> > +{
> > +	struct fsl_pwm_chip *fpc = platform_get_drvdata(pdev);
> > +
> > +	mutex_destroy(&fpc->lock);
> > +
> > +	return pwmchip_remove(&fpc->chip);
> 
> fpc->lock will be used while pwmchip_remove() is running so you should
> not be destroying it before calling pwmchip_remove(). It should probbaly
> go into free() method or just drop it altogether.
> 

Yes, I think I should drop it here as Thierry has already pointed out.


Thanks very much.

--
Best Regards,
Xiubo

