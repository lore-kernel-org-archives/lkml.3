Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3HSWu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:50:59 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41917 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3HSWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:50:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] gpio: pcf857x: Add OF support
Date: Tue, 20 Aug 2013 00:52:09 +0200
Message-ID: <5668808.mMAAfXl8cc@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdarBoKge2Z5wFW46KAsd0N942TYzpoxCRt0AmcU8ad0Rw@mail.gmail.com>
References: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375123145-31648-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CACRpkdarBoKge2Z5wFW46KAsd0N942TYzpoxCRt0AmcU8ad0Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Friday 16 August 2013 17:00:29 Linus Walleij wrote:
> On Mon, Jul 29, 2013 at 8:39 PM, Laurent Pinchart wrote:
> > Add DT bindings for the pcf857x-compatible chips and parse the device
> > tree node in the driver.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 69 +++++++++++++++++
>
> Do you think you can get one of the DT bindings mainatiners to ACK this
> part?

They're already CC'ed. I suppose vacations played a role in the lack of reply. 
I'd like to avoid having to switch to stalker mode ;-)

> I am told we need to get more strict on binding review.
> 
> It will be subject to timeout if it takes to long and you made a reasonable
> effort to get their consent though.
> 
> > +  - interrupt-controller: Identifies the node as an interrupt controller.
> > +  - #interrupt-cells: Number of cells to encode an interrupt source,
> > shall be 2.
> > +  - interrupt-parent: phandle of the parent interrupt controller.
> > +  - interrupts: Interrupt specifier for the controllers interrupt.
>
> So this is another one of of those GPIO controller that are also interrupt
> controllers.
> 
> So it will be subject to the same dilemma as the OMAP expander that has
> caused so much stir :-(
> 
> Can you provide your input in the discussion regarding my patch with the
> subject:
> "RFC: interrupt consistency check for OF GPIO IRQs"

Done.

> This patch will affect this driver also, in a very direct way, by just
> stealing and setting as input any GPIO line used for an IRQ.
> 
> > +Please refer to gpio.txt in this directory for details of the common GPIO
> > +bindings used by client devices.
> > +
> > +Example: PCF8575 I/O expander node
> > +
> > +       pcf8575: gpio@20 {
> > +               compatible = "nxp,pcf8575";
> > +               reg = <0x20>;
> > +               interrupt-parent = <&irqpin2>;
> > +               interrupts = <3 0>;
> > +               interrupt-controller;
> > +               #interrupt-cells = <2>;
> > +       };
> 
> Not gpio-controller?

I've fixed that in my tree already, it seems I forgot to repost. I will do so 
now.

> Apart from that it looks good, please help out with the gpio-controller vs
> interrupt-controller dilemma if you can because it's getting really
> frustrating...

-- 
Regards,

Laurent Pinchart
