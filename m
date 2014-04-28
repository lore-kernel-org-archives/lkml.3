Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaD1JlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:41:18 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:39996
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754480AbaD1JlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:41:15 -0400
Date: Mon, 28 Apr 2014 11:41:04 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] ARM: dts: Device tree for AXM55xx.
Message-ID: <20140428094104.GA21191@swsaberg01>
References: <cover.1398335771.git.anders.berg@lsi.com>
 <2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
 <CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
 <20140424174741.GA23444@swsaberg01>
 <CACRpkdZ1CA4mqcd5MA5HFmXSeGp-wspA0M6wnPbAsgL_gX76Fw@mail.gmail.com>
 <20140425094343.GA3160@swsaberg01>
 <CACRpkdaqPx3=qvUtsg44rBk+ZiscUg54HmNgETcei0LzfE9uOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdaqPx3=qvUtsg44rBk+ZiscUg54HmNgETcei0LzfE9uOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR03CA070.namprd03.prod.outlook.com (10.141.249.43) To
 BLUPR07MB372.namprd07.prod.outlook.com (10.141.26.152)
X-Forefront-PRVS: 01952C6E96
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(24454002)(51704005)(377454003)(199002)(189002)(42186004)(76482001)(23726002)(81542001)(99396002)(76176999)(54356999)(50986999)(92726001)(77982001)(85852003)(83322001)(19580405001)(19580395003)(46102001)(86362001)(74662001)(33716001)(80976001)(74502001)(4396001)(81342001)(97756001)(46406003)(87976001)(66066001)(80022001)(20776003)(47776003)(79102001)(83072002)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB372;H:swsaberg01;FPR:BCF4F89C.ADC21F0A.70ECBE54.C6EEB0D9.202D2;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:50:25PM +0200, Linus Walleij wrote:
> On Fri, Apr 25, 2014 at 11:43 AM, Anders Berg <anders.berg@lsi.com> wrote:
> > On Fri, Apr 25, 2014 at 11:16:18AM +0200, Linus Walleij wrote:
> >> On Thu, Apr 24, 2014 at 7:47 PM, Anders Berg <anders.berg@lsi.com> wrote:
> >> > On Thu, Apr 24, 2014 at 03:24:14PM +0200, Linus Walleij wrote:
> >>
> >> >> One interrupt per CPU core?
> >> >>
> >> >> The drivers for these blocks will really just grab the first IRQ and
> >> >> then I guess they
> >> >> will only be able to execute on CPU0.
> >> >>
> >> >> It's definately correct to list all the IRQs here, but how do you envision
> >> >> the drivers making use of them in the long run?
> >> >
> >> > It's one interrupt line per input pin (so with the current driver only the first pin
> >> > is usable as interrupt source).
> >>
> >> Hm I'm not sure I understand what a "pin" is in this concept ...
> >> being maintainer of the pin control subsystem and all that really
> >> triggers my interest.
> >>
> >
> > Ok, maybe should replace "pin" with "GPIO" in my previous comment.
> >
> > So, a clarification. In one of the PL061 blocks (named gpio0 in the dts) there
> > is a separate interrupt per GPIO (I assume the motivation here is to enable to
> > control irq affinity per GPIO), where as the other block has a more standard
> > configuration with a single interrupt for all 8 GPIOs in that block.
> 
> OK! I get it. Thus this is not a stock PL061, but a version modified to
> generate a separate IRQ line per GPIO line.
> 

I believe it's an unmodified PL061. Looking at the TRM, the PL061 interface
signals include a GPIOMIS[7:0] in addition to the GPIOINTR. So I guess by
hooking up the GPIOMIS[7:0] signals to the interrupt controller, you can get
this one-irq-per-gpio setup.

> This means that you can only get a proper, working IRQ from the
> first line on gpio0 right? All other IRQs will be ignored.

Right.


/Anders

