Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaH2Hji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:39:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:8204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaH2Hjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,423,1406617200"; 
   d="scan'208";a="565222551"
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
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>
Subject: Re: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
Thread-Topic: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
Thread-Index: AQHPwdzz6wDxZtCnpU+uwSWub4Ygq5vmEFIAgAEThYA=
Date: Fri, 29 Aug 2014 07:38:04 +0000
Message-ID: <1409297883.30155.29.camel@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	 <1409161588-19417-3-git-send-email-alvin.chen@intel.com>
	 <alpine.DEB.2.02.1408281007290.26299@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1408281007290.26299@atx-linux-37>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB08BCA516C8BA43817BDBC6326C36AB@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7T7dvI3023483

On Thu, 2014-08-28 at 10:11 -0500, atull wrote:
> On Wed, 27 Aug 2014, Weike Chen wrote:

[]

> > +static inline u32 dwapb_read(struct dwapb_gpio *gpio, unsigned int offset)
> > +{
> > +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> > +	void __iomem *reg_base	= gpio->regs;
> > +
> > +	return bgc->read_reg(reg_base + offset);
> > +}
> > +
> > +static inline void dwapb_write(struct dwapb_gpio *gpio, unsigned int offset,
> > +			       u32 val)
> > +{
> > +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> > +	void __iomem *reg_base	= gpio->regs;
> > +
> > +	bgc->write_reg(reg_base + offset, val);
> > +}
> > +
> 
> Hello,
> 
> I don't understand the reason for adding dwapb_read and dwapb_write here.  
> The rest of the driver is using readl and writel.  I'd rather not see two 
> different methods being used in the same driver for register access.  
> Maybe I'm missing something, but if we need to add dwapb_read/write, then
> it should be used for all register access.

Alan, it was my proposal. I rather agree that is better to convert all
accesses to that.

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
