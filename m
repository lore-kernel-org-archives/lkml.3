Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaIECJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:09:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:27515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbaIECJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381708909"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: RE: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPyF/xrVl5pOIy50CCjraIzroyT5vxx3yA
Date: Fri, 5 Sep 2014 02:09:22 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9826A6@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	<1409161588-19417-4-git-send-email-alvin.chen@intel.com>
 <CACRpkdZJSf+EfYN=hHxRnpjQZGuqroBL0c+08Ng=dRkS0GZySA@mail.gmail.com>
In-Reply-To: <CACRpkdZJSf+EfYN=hHxRnpjQZGuqroBL0c+08Ng=dRkS0GZySA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8529hx2014037

> 
> > +#if defined CONFIG_PM_SLEEP
> 
> I wonder whether it's worth #ifdef:in out such things, it clutters the place.
OK. I will use '#ifdef'.
> 
> > +/* Store GPIO context across system-wide suspend/resume transitions
> > +*/ static struct gpio_saved_regs {
> 
> Call the struct:
> 
> struct dwapb_context
> 
> because that is easier to understand.
> 
OK.

> > +       unsigned long data;
> > +       unsigned long dir;
> > +       unsigned long int_en;
> > +       unsigned long int_mask;
> > +       unsigned long int_type;
> > +       unsigned long int_pol;
> > +       unsigned long int_deb;
> > +} saved_regs;
> 
> Singleton huh?
> 
> Insert this into the dynamically allocated per-port or chip struct instead.
> 
How about the following?

static struct dwapb_context {
	u32 data[DWAPB_MAX_PORTS];
	u32 dir[DWAPB_MAX_PORTS];
	u32 ext[DWAPB_MAX_PORTS];
	u32 int_en;
	u32 int_mask;
	u32 int_type;
	u32 int_pol;
	u32 int_deb;
} dwapb_context;

Since only portA can support irq, and the irq related registers are only for portA. Comparing to allocate for each port
dynamically, it is more directly and easy to understand. 


> +       dwapb_write(gpio, GPIO_SWPORTA_DR, saved_regs.data);
> +       dwapb_write(gpio, GPIO_SWPORTA_DDR, saved_regs.dir);
> 
> And port B, C, D?
> 
> This looks like a crude hack.
I will add port B, C, D.
> 
> Yours,
> Linus Walleij
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
