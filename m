Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaIIJD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:03:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:13196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaIIJDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="588439588"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: Re: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPyNc/kBMLSfD+Nk6gyOY6CiHQz5vyMzuAgAAX0oCAACslvIAFiEkAgAB4bgA=
Date: Tue, 9 Sep 2014 09:01:44 +0000
Message-ID: <1410253304.25129.6.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E9829DA@SHSMSX101.ccr.corp.intel.com>
	 <1409918522.30155.89.camel@intel.com> <31986364.cn091cmIXU@wuerfel>
	 <4656BEB6164FC34F8171C6538F1A595B2E983296@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E983296@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8472BDCBB653DA4390AE67AADB58207B@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8993VMC004683

On Tue, 2014-09-09 at 01:50 +0000, Chen, Alvin wrote:
> > On Friday 05 September 2014 12:02:01 Shevchenko, Andriy wrote:
> > > > irq = irq_of_parse_and_map(node, 0); If (!irq) {
> > > > pp->irq = -1;
> > > > return;
> > > > } else {
> > > > pp->irq = irq;
> > > > }
> > > > Then the code looks strange.
> > > >
> > > > How do you think?
> > >
> > > If I understood correctly you messed up with hwirq vs. virq.
> > > Otherwise you have mention that you are using virq everywhere (I guess
> > > you may rename the field in the structure), but in this case the field
> > > in the platform_data looks a bit strange.
> > 
> > The field in platform_data should be the mapped virtual irq number, it makes no
> > sense to use the hwirq unless you also add a pointer to the domain in which
> > that hwirq exists.
> > 
> > Also the output of irq_of_parse_and_map() is a mapped irq, as the name
> > suggests.
> > 
> I agree with Arnd. Here, the 'irq' is 'virq'.
> Andriy, you may be confused by the code like 'irq_create_mapping'. For Quark case, it has 8 GPIO pins, and each pin can trigger
> interrupt, but all these interrupts are triggered by PCI irq which is shared. The 'irq' in pdata is PCI irq. As all GPIO interrupts connect to the PCI
> irq, once the GPIO interrupt is triggered, and the PCI irq handler will be called 'dwapb_irq_handler_mfd'. And in 'dwapb_do_irq', it will read the
> interrupt register to see the interrupt is triggered by which GPIO pin, and 'irq_create_mapping' is for this case.

Thanks for clarification. I take back my initial comment then.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
