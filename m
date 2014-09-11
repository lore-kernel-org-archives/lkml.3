Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaIKIAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:00:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:17085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaIKIAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="589712675"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "atull@opensource.altera.com" <atull@opensource.altera.com>
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
Thread-Topic: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPzBcrxlSNNsy4REqDrhjV17xohJv6rQ6AgADWroA=
Date: Thu, 11 Sep 2014 07:59:51 +0000
Message-ID: <1410422381.7023.15.camel@intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
	 <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
	 <alpine.DEB.2.02.1409101353500.2790@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1409101353500.2790@atx-linux-37>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <02B140BC09EDAA45A1366FC6FDB253C7@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B809fo021757

On Wed, 2014-09-10 at 14:11 -0500, atull wrote:

[]

> >  static int dwapb_gpio_probe(struct platform_device *pdev)
> >  {
> > +	int i;
> >  	struct resource *res;
> >  	struct dwapb_gpio *gpio;
> > -	struct device_node *np;
> >  	int err;
> > -	unsigned int offs = 0;
> > +	struct device *dev = &pdev->dev;
> > +	struct dwapb_platform_data *pdata = dev_get_platdata(dev);
> > +	bool is_pdata_alloc = !pdata;
> 
> Please combine the int's in one line (int err, i;) and put them as
> the last one on this list.  It looks the same to the compiler of
> course, but more uniform for human eyes :)

Do you think it's a good idea? In this case I, for example, would like
to see int err as a separate line at the end of definition block. It
would be better to distinguish counters and return code storage.
Moreover, often counters would be unsigned int.

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
