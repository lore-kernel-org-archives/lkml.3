Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaIKArK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:47:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:30364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaIKArH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,502,1406617200"; 
   d="scan'208";a="589546597"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: atull <atull@opensource.altera.com>
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
Thread-Topic: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPzVnU1B0Y5KNFyU6p2A+MOtzo+A==
Date: Thu, 11 Sep 2014 00:46:31 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E98F982@SHSMSX101.ccr.corp.intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
 <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
 <alpine.DEB.2.02.1409101353500.2790@atx-linux-37> 
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

> >
> > Hi Alvin,
> >
> > I did a quick test and this looks like it works for me (with device tree).
> > I had a couple of small fixes below.
> It is very appreciated to help testing.
> 
> 
> > Alan
> >
> > >
> > > -	port->bgc.gc.ngpio = ngpio;
> > > -	port->bgc.gc.of_node = port_np;
> > > +#ifdef CONFIG_OF_GPIO
> > > +	port->bgc.gc.of_node = pp->node;
> > > +#endif
> >
> > Please use 'if (IS_ENABLED(CONFIG_OF_GPIO)) as a conditional as you do
> > elsewhere.
> OK.
> 
Alan, I just do a quick test, here we can't use 'IS_ENABLED', it can't be compiled without OF_GPIO set.
Because 'gc.of_node' is not defined without 'OF_GPIO'. You can refer the structure of 'gc'.

