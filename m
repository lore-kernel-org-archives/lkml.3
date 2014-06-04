Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFDRHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:07:46 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:23391
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751361AbaFDRHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:07:44 -0400
Message-ID: <1401901656.6603.327.camel@snotra.buserror.net>
Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
From: Scott Wood <scottwood@freescale.com>
To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Jun 2014 12:07:36 -0500
In-Reply-To: <35f1762b80694ba4835cd7902a2faa0a@BLUPR03MB566.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
	 <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
	 <1401900111.6603.325.camel@snotra.buserror.net>
	 <35f1762b80694ba4835cd7902a2faa0a@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:197f:d7f3:edc1:8890]
X-ClientProxiedBy: BLUPR09CA003.namprd09.prod.outlook.com (10.255.219.141) To
 BL2PR03MB385.namprd03.prod.outlook.com (10.141.91.139)
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0232B30BBC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(189002)(199002)(13464003)(377424004)(24454002)(377454003)(50466002)(33646001)(86362001)(74662001)(80022001)(47776003)(20776003)(79102001)(50226001)(93886002)(99396002)(64706001)(92566001)(103116003)(92726001)(23676002)(4396001)(74502001)(31966008)(77156001)(81342001)(46102001)(102836001)(89996001)(101416001)(81542001)(50986999)(19580395003)(83322001)(87976001)(21056001)(85852003)(77982001)(83072002)(62966002)(87286001)(19580405001)(104166001)(42186004)(76176999)(76482001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB385;H:[IPv6:2601:2:5800:3f7:197f:d7f3:edc1:8890];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 12:04 -0500, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Wednesday, June 04, 2014 10:12 PM
> > To: Bhushan Bharat-R65777
> > Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
> > reporting driver
> > 
> > On Wed, 2014-06-04 at 03:17 -0500, Bhushan Bharat-R65777 wrote:
> > > > +static int ccf_remove(struct platform_device *pdev) {
> > > > +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> > > > +
> > > > +	switch (ccf->info->version) {
> > > > +	case CCF1:
> > > > +		iowrite32be(0, &ccf->err_regs->errdis);
> > > > +		break;
> > > > +
> > > > +	case CCF2:
> > > > +		iowrite32be(0, &ccf->err_regs->errinten);
> > >
> > > Do you think it is same to disable detection bits in ccf->err_regs->errdis?
> > 
> > Disabling the interrupt is what we're aiming for here, but ccf1 doesn't provide
> > a way to do that separate from disabling detection.
> 
> What I wanted to say that do we also need to disable detection (set
> ERRDET_LAE | ERRDET_CV bits in errdis) apart from clearing errinten on
> ccf2 ?

I don't think we "need" to.  You could argue that we should for
consistency, though I think there's value in errors continuing to be
detected even without the driver (e.g. can dump the registers in a
debugger).

-Scott


