Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaIKPrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:47:22 -0400
Received: from [157.56.110.55] ([157.56.110.55]:57312 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755551AbaIKPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:47:17 -0400
Date: Thu, 11 Sep 2014 10:40:58 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E98F982@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1409111039210.19272@atx-linux-37>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com> <1410286081-16653-2-git-send-email-alvin.chen@intel.com> <alpine.DEB.2.02.1409101353500.2790@atx-linux-37>  <4656BEB6164FC34F8171C6538F1A595B2E98F982@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(51704005)(52604005)(164054003)(24454002)(77096002)(92726001)(53416004)(83072002)(69596002)(50466002)(19580395003)(83322001)(76482001)(107046002)(95666004)(81342001)(86362001)(46102001)(4396001)(93886004)(101416001)(85306004)(86152002)(92566001)(85852003)(42186005)(90102001)(23726002)(97736003)(31966008)(74502001)(83506001)(74662001)(33716001)(66066001)(105586002)(80022001)(77982001)(79102001)(20776003)(21056001)(110136001)(81542001)(99396002)(106356001)(81156004)(76176999)(54356999)(50986999)(46406003)(47776003)(87976001)(102836001)(64706001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Chen, Alvin wrote:

> > >
> > > Hi Alvin,
> > >
> > > I did a quick test and this looks like it works for me (with device tree).
> > > I had a couple of small fixes below.
> > It is very appreciated to help testing.

Sure.  Thanks for adding features to the driver!

> > 
> > 
> > > Alan
> > >
> > > >
> > > > -	port->bgc.gc.ngpio = ngpio;
> > > > -	port->bgc.gc.of_node = port_np;
> > > > +#ifdef CONFIG_OF_GPIO
> > > > +	port->bgc.gc.of_node = pp->node;
> > > > +#endif
> > >
> > > Please use 'if (IS_ENABLED(CONFIG_OF_GPIO)) as a conditional as you do
> > > elsewhere.
> > OK.
> > 
> Alan, I just do a quick test, here we can't use 'IS_ENABLED', it can't be compiled without OF_GPIO set.
> Because 'gc.of_node' is not defined without 'OF_GPIO'. You can refer the structure of 'gc'.
> 

That makes sense.

Thanks,
Alan

