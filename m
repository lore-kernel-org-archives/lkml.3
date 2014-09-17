Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaIQGr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:47:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:7469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaIQGry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:47:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="604005969"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH 3/4 v4] GPIO: gpio-dwapb: Support Debounce
Thread-Topic: [PATCH 3/4 v4] GPIO: gpio-dwapb: Support Debounce
Thread-Index: AQHP0YmMm+616piTFkSgTqsVdHBL6ZwE4ziw
Date: Wed, 17 Sep 2014 06:47:35 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E99254E@SHSMSX101.ccr.corp.intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
	 <1410859335-11080-4-git-send-email-alvin.chen@intel.com>
 <1410856669.7023.54.camel@linux.intel.com>
In-Reply-To: <1410856669.7023.54.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8H6m0VC000577

> > +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> > +	struct dwapb_gpio_port *port =
> > +			container_of(bgc, struct dwapb_gpio_port, bgc);
> 
> Does it make sense to introduce an inline helper like
> 
> static inline struct dwapb_gpio_port *to_dwapb_gpio_port(struct bgpio_chip
> *gc) {...}
> 
> ?

OK.

> There is also another place where it could be used.
> 
> > +	struct dwapb_gpio *gpio = port->gpio;
> > +	unsigned long flags, val_deb;
> > +	unsigned long mask = bgc->pin2mask(bgc, offset);
> > +
> > +	spin_lock_irqsave(&bgc->lock, flags);
> > +
> > +	val_deb = dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
> > +	if (debounce)
> > +		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, mask | val_deb);
> 
> May you put value on the first place? Like 'val_deb | mask'.

OK.

> > +	else
> > +		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, ~mask & val_deb);
> 
> Ditto.
> 
OK.
> > +

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
