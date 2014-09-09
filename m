Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaIIBUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:20:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:61613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbaIIBUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,489,1406617200"; 
   d="scan'208";a="570285196"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: RE: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPyP+JkBMLSfD+Nk6gyOY6CiHQz5v4BmAA
Date: Tue, 9 Sep 2014 01:20:29 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E983253@SHSMSX101.ccr.corp.intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
 <1409928798-31895-2-git-send-email-alvin.chen@intel.com>
 <3465722.Gc9y01nQRe@wuerfel>
In-Reply-To: <3465722.Gc9y01nQRe@wuerfel>
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
> > +#ifdef CONFIG_OF_GPIO
> > +
> > +static struct dwapb_platform_data *
> > +dwapb_gpio_get_pdata_of(struct device *dev) {
> > +	struct device_node *node, *port_np;
> > +	struct dwapb_platform_data *pdata;
> > +	struct dwapb_port_property *pp;
> > +	int nports;
> > +	int i;
> > +
> > +	node = dev->of_node;
> > +	if (!node)
> > +		return ERR_PTR(-ENODEV);
> 
> Please replace the #ifdef above with
> 
> 	if (!IS_ENABLED(CONFIG_OF_GPIO) || !node)
> 
> here so get you proper compile-time coverage of the DT code path.
OK, I will improve it.
