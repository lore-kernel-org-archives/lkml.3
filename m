Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaIQGq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:46:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:39712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaIQGqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:46:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="604005529"
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
Subject: RE: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHP0X+R/+uxq9SP7kqT9UolCDPFE5wE4jbg
Date: Wed, 17 Sep 2014 06:46:11 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E99253F@SHSMSX101.ccr.corp.intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
	 <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
 <1410852405.7023.48.camel@linux.intel.com>
In-Reply-To: <1410852405.7023.48.camel@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8H6l3aE000568

> 
> > Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> 
> You still keep that guy as reviewer in a whole series, however I didn't see a
> word from him here. How is it possible?
In our internal review, he gave me a lot of suggestions. 

> > +	for (i = 0; i < gpio->nr_ports; i++) {
> > +		unsigned int offset;
> > +		unsigned int idx = gpio->ports[i].idx;
> > +		struct dwapb_context *ctx = gpio->ports[i].ctx;
> > +
> > +		if (!ctx) {
> > +			ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
> > +			gpio->ports[i].ctx = ctx;
> > +		}
> 
> I don't think it's a right place to allocate this resource, especially with devm_
> helper. Can you move this to probe() stage?
> 
> Or you even can embed contex structure inside chip one with #ifdef
> CONFIG_PM_SLEEP.
> 

OK, I will improve it.

> Maybe others could comment on this.
> 
> > +
> > +		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
> 
> No need to have parentheses here. Check the code below as well.
OK. I will remove them.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
