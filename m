Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaIJKcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:32:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:24307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaIJKcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:32:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,498,1406617200"; 
   d="scan'208";a="571067315"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Darren Hart <dvhart@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPzI8IMspPYHZrw0K1hKT+7ysaLZv5Lt4AgAD7xSA=
Date: Wed, 10 Sep 2014 10:32:08 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E98F878@SHSMSX101.ccr.corp.intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
 <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
 <D034802C.A7BEE%dvhart@linux.intel.com>
 <4656BEB6164FC34F8171C6538F1A595B2E98854F@SHSMSX101.ccr.corp.intel.com>
 <20140910032646.GA39541@vmdeb7>
In-Reply-To: <20140910032646.GA39541@vmdeb7>
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

> > > You cover this specific dependencies with inline ifdefs, but you
> > > lose the CONFIG_OF depends by dropping it, and there are no such
> > > checks in the probe routine. Assumptions of OF are not limited to probe in
> this driver.
> > >
> > > While I would like to see this assumption properly abstracted, the
> > > most expedient/immediate fix is probably to add a depends on OF above.
> >
> > Andriy, how do you think?
> >
> > How about
> > depends on OF_GPIO || MFD_GPIO_DWAPB, or depends on OF_GPIO ||
> > MFD_INTEL_QUARK_I2C_GPIO?
> >
> 
> Upon closer inspection, I think my concern is invalid. the OF header already
> tests for CONFIG_OF and provides no-op / -ENOSYS (tsk tsk) alternatives. So
> long as you can compile with "#CONFIG_OF is not set" as it is, then I withdraw
> my comment.
Yes, it can be compiled with "#CONFIG_OF is not set" and "#CONFIG_OF_GPIO is not set"

> 
> Sorry for the noise.
> 
> --
> Darren Hart
> Intel Open Source Technology Center
