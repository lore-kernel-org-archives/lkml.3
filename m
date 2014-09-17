Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaIQHKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:10:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:32023 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaIQHKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:10:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="604014289"
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
Subject: RE: [PATCH 1/4 v4] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/4 v4] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHP0kZaE0Vi3BL3eUKo11TffOaDXQ==
Date: Wed, 17 Sep 2014 07:09:42 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9925AB@SHSMSX101.ccr.corp.intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
 <1410859335-11080-2-git-send-email-alvin.chen@intel.com>
 <alpine.DEB.2.02.1409160921020.4740@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1409160921020.4740@atx-linux-37>
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

> > +		if (pp->idx == 0 &&
> > +		    of_property_read_bool(port_np, "interrupt-controller")) {
> > +			pp->irq = irq_of_parse_and_map(port_np, 0);
> > +			if (!pp->irq) {
> > +				dev_warn(dev, "no irq for bank %s\n",
> > +					 port_np->full_name);
> > +			}
> > +		} else {
> > +			pp->irq	= 0;
> > +		}
> 
> The else clause is not needed since pp->irq == 0 already, right?
> 
Yes, while call kcalloc, the memory is set to '0'. I will improve it.
