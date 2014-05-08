Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaEHOqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:46:39 -0400
Received: from [207.46.163.244] ([207.46.163.244]:43989 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856AbaEHOqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:46:37 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 10:46:37 EDT
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>,
        "balbi@ti.com" <balbi@ti.com>, Paul Fertser <fercerpav@gmail.com>
CC: "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Topic: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Index: AQHPX6Pn9DI4D60kV0aDe0wVb6zR3psqXP2AgAA4QYCAAAxfAIABL2ZggAsBoqA=
Date: Thu, 8 May 2014 14:30:39 +0000
Message-ID: <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
 <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan>
 <20140430201202.GF3839@saruman.home>
 <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com>
In-Reply-To: <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(13464003)(24454002)(377454003)(77096999)(74662001)(15202345003)(50986999)(76176999)(83072002)(54356999)(31966008)(85852003)(74316001)(92566001)(74502001)(46102001)(81342001)(81542001)(76576001)(4396001)(76482001)(64706001)(99286001)(99396002)(77982001)(86362001)(20776003)(33646001)(15975445006)(101416001)(79102001)(19580395003)(19580405001)(83322001)(87936001)(21056001)(66066001)(2656002)(80022001)(24736002)(422495003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB387;H:BL2PR03MB579.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=suresh.gupta@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As per my limited knowledge, the purpose of OTGSC_STS_B_SESSION_VALID bit is to tell either VBUS is above the B session valid threshold and which comes only Host is attached.
And Host might be attach after system bootup or after driver initialization. So putting this check in probe will not help much.

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of suresh.gupta@freescale.com
> Sent: Thursday, May 01, 2014 7:58 PM
> To: balbi@ti.com; Paul Fertser
> Cc: Li Yang-Leo-R58472; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] usb: gadget: fsl: check vbus presence on probe
> 
> Give me some time (actually some days), I will try this and update you.
> 
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, May 01, 2014 1:42 AM
> > To: Paul Fertser
> > Cc: Felipe Balbi; Li Yang-Leo-R58472; linux-usb@vger.kernel.org;
> > linux- kernel@vger.kernel.org; Gupta Suresh-B42813
> > Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
> >
> > +Suresh
> >
> > (top-posting, yeah yeah :-)
> >
> > On Wed, Apr 30, 2014 at 11:27:45PM +0400, Paul Fertser wrote:
> > > Hello,
> > >
> > > Thank you for the review.
> > >
> > > On Wed, Apr 30, 2014 at 11:06:25AM -0500, Felipe Balbi wrote:
> > > > On Thu, Apr 24, 2014 at 12:54:13PM +0400, Paul Fertser wrote:
> > > > > If VBUS is already present during the driver initialisation, the
> > > >
> > > > s/initialisation/initialization
> > >
> > > If I'm understanding [1] properly, both spelling variants are
> correct.
> > >
> > > > > +	/* Now let it settle a bit and sense VBUS */
> > > > > +	msleep_interruptible(1);
> > > > > +	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
> > > > > +		udc_controller->vbus_active = 1;
> > > >
> > > > good fix, should this go to stable ?
> > >
> > > I was reluctant to Cc stable because I'm not sure which versions
> > > need to be fixed, as I've seen an earlier version (3.0 something or
> > > a bit before that probably) working without this (no idea why); also
> > > I'm not sure about that msleep as it's deduced solely from
> > > experimenting with a particular i.MX model, I hoped someone from
> > > Freescale would comment on it. I've seen your review [2] on a
> > > related patch and my fix should have been obvious to Suresh (and
> > > trivial to test on different boards), yet he didn't implement it,
> that worries me a bit.
> > >
> > > [1]
> > > https://en.wikipedia.org/wiki/American_and_British_English_spelling_
> > > di
> > > fferences#-ise.2C_-ize_.28-isation.2C_-ization.29
> > > [2] https://patchwork.kernel.org/patch/3822321/
> > > --
> > > Be free, use free (http://www.gnu.org/philosophy/free-sw.html)
> > software!
> > > mailto:fercerpav@gmail.com
> >
> > --
> > balbi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
