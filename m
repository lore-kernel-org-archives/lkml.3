Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaF3U7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:59:55 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:15195
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbaF3U7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:59:54 -0400
Message-ID: <1404161983.2435.182.camel@snotra.buserror.net>
Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
From: Scott Wood <scottwood@freescale.com>
To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2014 15:59:43 -0500
In-Reply-To: <806516468c994e638fc9214b0e5a7b9f@DM2PR03MB574.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
	 <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
	 <1401900111.6603.325.camel@snotra.buserror.net>
	 <35f1762b80694ba4835cd7902a2faa0a@BLUPR03MB566.namprd03.prod.outlook.com>
	 <1401901656.6603.327.camel@snotra.buserror.net>
	 <806516468c994e638fc9214b0e5a7b9f@DM2PR03MB574.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:ec75:944b:59fa:be6]
X-ClientProxiedBy: BY2PR01CA0051.prod.exchangelabs.com (10.255.242.41) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0258E7CCD4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199002)(189002)(13464003)(377424004)(51704005)(24454002)(377454003)(107046002)(77156001)(93886003)(50226001)(106356001)(83322001)(46102001)(19580395003)(19580405001)(95666004)(31966008)(77096002)(21056001)(105586002)(87286001)(74662001)(4396001)(104166001)(62966002)(85306003)(42186005)(74502001)(23676002)(101416001)(79102001)(85852003)(83072002)(89996001)(80022001)(88136002)(81542001)(76176999)(50986999)(87976001)(81342001)(103116003)(99396002)(86362001)(93916002)(92566001)(92726001)(76482001)(33646001)(102836001)(77982001)(50466002)(47776003)(64706001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:ec75:944b:59fa:be6];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-29 at 23:58 -0500, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Wednesday, June 04, 2014 10:38 PM
> > To: Bhushan Bharat-R65777
> > Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
> > reporting driver
> > 
> > On Wed, 2014-06-04 at 12:04 -0500, Bhushan Bharat-R65777 wrote:
> > >
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Wednesday, June 04, 2014 10:12 PM
> > > > To: Bhushan Bharat-R65777
> > > > Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> > > > kernel@vger.kernel.org
> > > > Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency
> > > > Fabric error reporting driver
> > > >
> > > > On Wed, 2014-06-04 at 03:17 -0500, Bhushan Bharat-R65777 wrote:
> > > > > > +static int ccf_remove(struct platform_device *pdev) {
> > > > > > +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> > > > > > +
> > > > > > +	switch (ccf->info->version) {
> > > > > > +	case CCF1:
> > > > > > +		iowrite32be(0, &ccf->err_regs->errdis);
> > > > > > +		break;
> > > > > > +
> > > > > > +	case CCF2:
> > > > > > +		iowrite32be(0, &ccf->err_regs->errinten);
> > > > >
> > > > > Do you think it is same to disable detection bits in ccf->err_regs-
> > >errdis?
> > > >
> > > > Disabling the interrupt is what we're aiming for here, but ccf1
> > > > doesn't provide a way to do that separate from disabling detection.
> > >
> > > What I wanted to say that do we also need to disable detection (set
> > > ERRDET_LAE | ERRDET_CV bits in errdis) apart from clearing errinten on
> > > ccf2 ?
> > 
> > I don't think we "need" to.  You could argue that we should for consistency,
> > though I think there's value in errors continuing to be detected even without
> > the driver (e.g. can dump the registers in a debugger).
> 
> Yes this comment was for consistency. Also IIUC, the state which is left when the driver is removed is not default reset behavior.

How many drivers leave the hardware in pristine reset state when
exiting?  And you could argue that having detection off by default is
poor hardware design (enabling interrupts is another matter of course).

> If we want errors to be detected then should not we have a sysfs interface?

That may be useful but it's beyond the scope of what I'm doing with this
patch.  We currently don't log machine checks anywhere but via printk
either.

BTW, I thought I had sent v2 of this, but I don't see it anywhere...
I'll respin soon.

-Scott


