Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaEAOmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:42:55 -0400
Received: from [207.46.163.181] ([207.46.163.181]:50290 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751286AbaEAOmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:42:53 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>, Paul Fertser <fercerpav@gmail.com>
CC: "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Topic: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Index: AQHPX6Pn9DI4D60kV0aDe0wVb6zR3psqXP2AgAA4QYCAAAxfAIABL2Zg
Date: Thu, 1 May 2014 14:27:30 +0000
Message-ID: <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
 <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan>
 <20140430201202.GF3839@saruman.home>
In-Reply-To: <20140430201202.GF3839@saruman.home>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377454003)(199002)(189002)(24454002)(13464003)(20776003)(83072002)(66066001)(2656002)(79102001)(50986999)(99396002)(31966008)(77096999)(76176999)(54356999)(77982001)(46102001)(87936001)(85852003)(76482001)(74502001)(80022001)(92566001)(86362001)(19580395003)(33646001)(15202345003)(76576001)(19580405001)(4396001)(15975445006)(99286001)(83322001)(81342001)(101416001)(80976001)(74316001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB385;H:BL2PR03MB579.namprd03.prod.outlook.com;FPR:FEFCF51A.27FB9C89.73FD91FF.96F6F8F1.20344;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give me some time (actually some days), I will try this and update you.

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, May 01, 2014 1:42 AM
> To: Paul Fertser
> Cc: Felipe Balbi; Li Yang-Leo-R58472; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Gupta Suresh-B42813
> Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
> 
> +Suresh
> 
> (top-posting, yeah yeah :-)
> 
> On Wed, Apr 30, 2014 at 11:27:45PM +0400, Paul Fertser wrote:
> > Hello,
> >
> > Thank you for the review.
> >
> > On Wed, Apr 30, 2014 at 11:06:25AM -0500, Felipe Balbi wrote:
> > > On Thu, Apr 24, 2014 at 12:54:13PM +0400, Paul Fertser wrote:
> > > > If VBUS is already present during the driver initialisation, the
> > >
> > > s/initialisation/initialization
> >
> > If I'm understanding [1] properly, both spelling variants are correct.
> >
> > > > +	/* Now let it settle a bit and sense VBUS */
> > > > +	msleep_interruptible(1);
> > > > +	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
> > > > +		udc_controller->vbus_active = 1;
> > >
> > > good fix, should this go to stable ?
> >
> > I was reluctant to Cc stable because I'm not sure which versions need
> > to be fixed, as I've seen an earlier version (3.0 something or a bit
> > before that probably) working without this (no idea why); also I'm not
> > sure about that msleep as it's deduced solely from experimenting with
> > a particular i.MX model, I hoped someone from Freescale would comment
> > on it. I've seen your review [2] on a related patch and my fix should
> > have been obvious to Suresh (and trivial to test on different boards),
> > yet he didn't implement it, that worries me a bit.
> >
> > [1]
> > https://en.wikipedia.org/wiki/American_and_British_English_spelling_di
> > fferences#-ise.2C_-ize_.28-isation.2C_-ization.29
> > [2] https://patchwork.kernel.org/patch/3822321/
> > --
> > Be free, use free (http://www.gnu.org/philosophy/free-sw.html)
> software!
> > mailto:fercerpav@gmail.com
> 
> --
> balbi
