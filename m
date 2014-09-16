Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaIPBHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:07:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:37706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbaIPBHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="386551199"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "'linus.walleij@linaro.org'" <linus.walleij@linaro.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'robh+dt@kernel.org'" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "'gnurou@gmail.com'" <gnurou@gmail.com>,
        "'linus.walleij@linaro.org'" <linus.walleij@linaro.org>,
        "'linux-gpio@vger.kernel.org'" <linux-gpio@vger.kernel.org>,
        "'sebastian@breakpoint.cc'" <sebastian@breakpoint.cc>,
        "'grant.likely@linaro.org'" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "'dvhart@linux.intel.com'" <dvhart@linux.intel.com>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'atull'" <atull@opensource.altera.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: RE: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHP0ILxaGk/ya5Mn0yC06Al/AQx+JwC8VUg
Date: Tue, 16 Sep 2014 01:07:31 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9918D4@SHSMSX101.ccr.corp.intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
  <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
  <alpine.DEB.2.02.1409101353500.2790@atx-linux-37>
 <1410422381.7023.15.camel@intel.com>
 <alpine.DEB.2.02.1409111020130.19272@atx-linux-37>
 <4656BEB6164FC34F8171C6538F1A595B2E9915E6@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E9915E6@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > >
> > > > >  static int dwapb_gpio_probe(struct platform_device *pdev)  {
> > > > > +	int i;
> > > > >  	struct resource *res;
> > > > >  	struct dwapb_gpio *gpio;
> > > > > -	struct device_node *np;
> > > > >  	int err;
> > > > > -	unsigned int offs = 0;
> > > > > +	struct device *dev = &pdev->dev;
> > > > > +	struct dwapb_platform_data *pdata = dev_get_platdata(dev);
> > > > > +	bool is_pdata_alloc = !pdata;
> > > >
> > > > Please combine the int's in one line (int err, i;) and put them as
> > > > the last one on this list.  It looks the same to the compiler of
> > > > course, but more uniform for human eyes :)
> > >
> > > Do you think it's a good idea? In this case I, for example, would
> > > like to see int err as a separate line at the end of definition
> > > block. It would be better to distinguish counters and return code storage.
> > > Moreover, often counters would be unsigned int.
> >
> > If they are both 'int' they should be combined.  If 'i' is changed to
> > be an unsigned int they would be separate.
> 
> Linus, do you have any idea about it? I think it is not a big issue.
> >

Since no further feedbacks, I decide to use 'unsigned int i' to align the two feedbacks, since 'i' is just a counter.
And will send a new version with just this changes later.
