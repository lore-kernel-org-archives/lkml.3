Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaGHP4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:56:08 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:9222
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753861AbaGHP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:56:05 -0400
Date: Tue, 8 Jul 2014 08:55:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harini Katakam <harini.katakam@xilinx.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
 <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
 <d1af864d-bf78-48bb-a545-8de3f9def75f@BL2FFO11FD037.protection.gbl>
 <CACRpkdYSU6NdFuab6rJS7eADSqORNDBzbFfJ65nFoJj3EZVd-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYSU6NdFuab6rJS7eADSqORNDBzbFfJ65nFoJj3EZVd-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3adb614c-38ae-4b0c-9e50-99f071bbf4c5@BL2FFO11FD038.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377454003)(199002)(189002)(24454002)(51914003)(51704005)(377424004)(50466002)(19580395003)(19580405001)(6806004)(83322001)(85852003)(74502001)(83072002)(83506001)(87936001)(85182001)(74316001)(77096002)(44976005)(92726001)(85306003)(102836001)(23676002)(86362001)(92566001)(31696002)(93886003)(81342001)(50986999)(81542001)(4396001)(21056001)(76176999)(54356999)(70736001)(99396002)(31966008)(74662001)(107046002)(33646001)(95666004)(1496007)(77982001)(104016002)(53416004)(76482001)(64706001)(85202003)(46102001)(20776003)(47776003)(110136001)(80022001)(106466001)(79102001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB048;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 2014-07-08 at 11:34AM +0200, Linus Walleij wrote:
> On Mon, Jul 7, 2014 at 6:08 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> >> So: what is the usecase for these GPIOs?
> >
> > Yea, in this case it was a button. I have to look at these drivers. It's
> > very likely that they cover what I want. But this case is trivial. I
> > really don't do anything but enabling the IRQ by writing to the edge
> > attribute and press the push-button connected to that GPIO line.
> 
> In case of a system using device tree it is very trivial to add a gpio
> key binding. After compiling in the gpio keys driver this small
> snipper type is all that is really needed in most cases:
> 
>         /* User key mapped in as "escape" */
>         gpio-keys {
>                 compatible = "gpio-keys";
>                 user-button {
>                         label = "user_button";
>                         gpios = <&gpio0 3 0x1>;
>                         linux,code = <1>; /* KEY_ESC */
>                         gpio-key,wakeup;
>                 };
>         };

Thanks for the example. I think for my cases these drivers are exactly
the right thing.

> 
> 
> > But as a general note: I think we have quite some customers trying to do
> > GPIO in userspace.
> 
> For what? I mean the use cases. Usually it is a bad idea, and
> as shown above, just using the right existing device driver with
> device tree is much easier, also for an end user, given they know
> how to alter DTs and compile in kernel modules.
> 
> > With Zynq's FPGA portion, a lot of things come down
> > to make signals accessible in Linux and a lot of people do not want or
> > need a full blown kernel driver and use GPIO. The request for 'how to
> > handle GPIO IRQs in userspace' is pretty common. Often this gets passed
> > on to UIO though.
> 
> The short answer is don't handle GPIO IRQs in userspace.
> 
> Userspace drivers is generally a bad idea and should not be written.
> The kernel is intended to handle hardware.
> 
> The above is doubly true for anything involving IRQs. Just think
> of what IRQs are. They are one of the reasons why we have a
> kernel and not just write all software on a system from scratch
> ourselves.

I fully agree and you don't have to convince me. But to a lot of our
customers that are used to use FPGAs, SOCs and Linux are pretty new. You
see a lot of scary stuff. Accessing /dev/mem seems to be a lot of
people's big hammer solution for everything. Then I always perceive it
as great progress if things like the sysfs interface are used instead.

	Thanks,
	Sören

