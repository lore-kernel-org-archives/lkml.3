Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaIKPrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:47:17 -0400
Received: from [157.56.111.57] ([157.56.111.57]:58080 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146AbaIKPrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:47:14 -0400
X-Greylist: delayed 73805 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 11:47:13 EDT
Date: Thu, 11 Sep 2014 10:26:09 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
In-Reply-To: <1410422381.7023.15.camel@intel.com>
Message-ID: <alpine.DEB.2.02.1409111020130.19272@atx-linux-37>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>  <1410286081-16653-2-git-send-email-alvin.chen@intel.com>  <alpine.DEB.2.02.1409101353500.2790@atx-linux-37> <1410422381.7023.15.camel@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA027.namprd06.prod.outlook.com (10.242.160.17) To
 BLUPR03MB311.namprd03.prod.outlook.com (10.141.48.26)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(377424004)(199003)(36304003)(51704005)(189002)(66066001)(64706001)(21056001)(85306004)(93886004)(80022001)(74502001)(46406003)(20776003)(47776003)(81342001)(95666004)(15975445006)(110136001)(46102001)(107046002)(81542001)(74662001)(101416001)(31966008)(23726002)(85852003)(102836001)(53416004)(83072002)(99396002)(19580395003)(50466002)(33716001)(92566001)(50986999)(86152002)(54356999)(76176999)(92726001)(69596002)(86362001)(4396001)(81156004)(19580405001)(77096002)(87976001)(79102001)(97736003)(83506001)(42186005)(83322001)(106356001)(76482001)(105586002)(90102001)(77982001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB311;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Shevchenko, Andriy wrote:

> On Wed, 2014-09-10 at 14:11 -0500, atull wrote:
> 
> []
> 
> > >  static int dwapb_gpio_probe(struct platform_device *pdev)
> > >  {
> > > +	int i;
> > >  	struct resource *res;
> > >  	struct dwapb_gpio *gpio;
> > > -	struct device_node *np;
> > >  	int err;
> > > -	unsigned int offs = 0;
> > > +	struct device *dev = &pdev->dev;
> > > +	struct dwapb_platform_data *pdata = dev_get_platdata(dev);
> > > +	bool is_pdata_alloc = !pdata;
> > 
> > Please combine the int's in one line (int err, i;) and put them as
> > the last one on this list.  It looks the same to the compiler of
> > course, but more uniform for human eyes :)
> 
> Do you think it's a good idea? In this case I, for example, would like
> to see int err as a separate line at the end of definition block. It
> would be better to distinguish counters and return code storage.
> Moreover, often counters would be unsigned int.

If they are both 'int' they should be combined.  If 'i' is changed to be
an unsigned int they would be separate.

> 
> -- 
> Andy Shevchenko <andriy.shevchenko@intel.com>
> Intel Finland Oy
> ---------------------------------------------------------------------
> Intel Finland Oy
> Registered Address: PL 281, 00181 Helsinki 
> Business Identity Code: 0357606 - 4 
> Domiciled in Helsinki 
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 

Andy,

This confidentiality footer is problematic on this mailing list.  Please
see https://lkml.org/lkml/2014/3/5/790 for example.

Alan
