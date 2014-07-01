Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaGAEQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:16:54 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:34119
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874AbaGAEQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:16:53 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Topic: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Index: AQHPfFZ5AO8lYHxFT069YHO6X2X6YptgmrRggACUZICAAAVDUIAAAe4AgCgMmMCAARDggIAAa44A
Date: Tue, 1 Jul 2014 04:16:48 +0000
Message-ID: <4256125352774a7898fe284927b41c2d@DM2PR03MB574.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
	 <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
	 <1401900111.6603.325.camel@snotra.buserror.net>
	 <35f1762b80694ba4835cd7902a2faa0a@BLUPR03MB566.namprd03.prod.outlook.com>
	 <1401901656.6603.327.camel@snotra.buserror.net>
	 <806516468c994e638fc9214b0e5a7b9f@DM2PR03MB574.namprd03.prod.outlook.com>
 <1404161983.2435.182.camel@snotra.buserror.net>
In-Reply-To: <1404161983.2435.182.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02596AB7DA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(377424004)(24454002)(51704005)(189002)(199002)(13464003)(101416001)(79102001)(54356999)(66066001)(83072002)(85852003)(74502001)(2656002)(85306003)(33646001)(92566001)(76482001)(64706001)(20776003)(77982001)(87936001)(81342001)(50986999)(81542001)(76176999)(80022001)(86362001)(99396002)(19580405001)(83322001)(95666004)(99286002)(93886003)(107046002)(76576001)(106116001)(106356001)(105586002)(46102001)(19580395003)(74662001)(74316001)(4396001)(31966008)(21056001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB398;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s614H1Zl019195



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, July 01, 2014 2:30 AM
> To: Bhushan Bharat-R65777
> Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
> reporting driver
> 
> On Sun, 2014-06-29 at 23:58 -0500, Bhushan Bharat-R65777 wrote:
> >
> > > -----Original Message-----
> > > From: Wood Scott-B07421
> > > Sent: Wednesday, June 04, 2014 10:38 PM
> > > To: Bhushan Bharat-R65777
> > > Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> > > kernel@vger.kernel.org
> > > Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency
> > > Fabric error reporting driver
> > >
> > > On Wed, 2014-06-04 at 12:04 -0500, Bhushan Bharat-R65777 wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Wood Scott-B07421
> > > > > Sent: Wednesday, June 04, 2014 10:12 PM
> > > > > To: Bhushan Bharat-R65777
> > > > > Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> > > > > kernel@vger.kernel.org
> > > > > Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency
> > > > > Fabric error reporting driver
> > > > >
> > > > > On Wed, 2014-06-04 at 03:17 -0500, Bhushan Bharat-R65777 wrote:
> > > > > > > +static int ccf_remove(struct platform_device *pdev) {
> > > > > > > +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> > > > > > > +
> > > > > > > +	switch (ccf->info->version) {
> > > > > > > +	case CCF1:
> > > > > > > +		iowrite32be(0, &ccf->err_regs->errdis);
> > > > > > > +		break;
> > > > > > > +
> > > > > > > +	case CCF2:
> > > > > > > +		iowrite32be(0, &ccf->err_regs->errinten);
> > > > > >
> > > > > > Do you think it is same to disable detection bits in
> > > > > > ccf->err_regs-
> > > >errdis?
> > > > >
> > > > > Disabling the interrupt is what we're aiming for here, but ccf1
> > > > > doesn't provide a way to do that separate from disabling detection.
> > > >
> > > > What I wanted to say that do we also need to disable detection
> > > > (set ERRDET_LAE | ERRDET_CV bits in errdis) apart from clearing
> > > > errinten on
> > > > ccf2 ?
> > >
> > > I don't think we "need" to.  You could argue that we should for
> > > consistency, though I think there's value in errors continuing to be
> > > detected even without the driver (e.g. can dump the registers in a
> debugger).
> >
> > Yes this comment was for consistency. Also IIUC, the state which is left when
> the driver is removed is not default reset behavior.
> 
> How many drivers leave the hardware in pristine reset state when exiting?

I do not know :)

>  And
> you could argue that having detection off by default is poor hardware design
> (enabling interrupts is another matter of course).

Ok, then can you please add a comment in _remove() function describing why detection is still enabled.

Thanks
-Bharat

> 
> > If we want errors to be detected then should not we have a sysfs interface?
> 
> That may be useful but it's beyond the scope of what I'm doing with this patch.
> We currently don't log machine checks anywhere but via printk either.
> 
> BTW, I thought I had sent v2 of this, but I don't see it anywhere...
> I'll respin soon.
> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
