Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaILQIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:08:38 -0400
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:40016
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751445AbaILQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:08:34 -0400
X-Greylist: delayed 946 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 12:08:34 EDT
Date: Fri, 12 Sep 2014 10:46:54 -0500
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
Subject: RE: [PATCH 4/4 v3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E990CFF@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1409121045070.373@atx-linux-37>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com> <1410286081-16653-5-git-send-email-alvin.chen@intel.com> <alpine.DEB.2.02.1409111138080.4869@atx-linux-37> <4656BEB6164FC34F8171C6538F1A595B2E990CFF@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0012.namprd02.prod.outlook.com (10.141.56.12) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(99396002)(85306004)(79102001)(93886004)(81542001)(83072002)(33716001)(92726001)(92566001)(83506001)(86362001)(95666004)(74502001)(102836001)(107046002)(31966008)(87976001)(74662001)(77096002)(85852003)(77982001)(23726002)(81342001)(54356999)(69596002)(101416001)(105586002)(50986999)(106356001)(80022001)(83322001)(46102001)(81156004)(53416004)(66066001)(42186005)(110136001)(46406003)(97736003)(86152002)(76176999)(64706001)(47776003)(90102001)(20776003)(21056001)(50466002)(4396001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Chen, Alvin wrote:

> > On Tue, 9 Sep 2014, Weike Chen wrote:
> > 
> > >
> > >  struct dwapb_gpio;
> > > +struct dwapb_context;
> > >
> > >  struct dwapb_gpio_port {
> > >  	struct bgpio_chip	bgc;
> > >  	bool			is_registered;
> > >  	struct dwapb_gpio	*gpio;
> > > +	struct dwapb_context	*ctx;
> > 
> > Alvin,
> > 
> > Will this build if CONFIG_PM_SLEEP is not defined?
> Actually, PM_SLEEP is always set as 'y' in 'kerne/power/Kconfig'. But I manually change it to 'n', this module can be compiled correctly.
> You may be concern with 'ctx', and you can see 'ctx' accessing is always in CONFIG_PM_SLEEP.

Yes and in the case of 'struct dwapb_context *ctx;' it is ok for struct 
dwapb_context to be an incomplete type since that's just a pointer.

Alan 
