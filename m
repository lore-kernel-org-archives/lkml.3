Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaJGQbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:31:04 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53607 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaJGQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:31:03 -0400
Date: Tue, 7 Oct 2014 11:30:53 -0500
From: Michael Welling <mwelling@emacinc.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: GPIO registration for external Ethernet PHY oscillator
 enable/disable
Message-ID: <20141007163053.GA6123@sysresccd>
References: <20140923215226.GA29000@sysresccd>
 <20140925191722.GA2481@sysresccd>
 <CACRpkdYL-AQPDOZNrmeOeKbb+DvXBHB+hz37M+v_qKwzPzkApA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYL-AQPDOZNrmeOeKbb+DvXBHB+hz37M+v_qKwzPzkApA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:04:27PM +0200, Linus Walleij wrote:
> On Thu, Sep 25, 2014 at 9:17 PM, Michael Welling <mwelling@emacinc.com> wrote:
> 
> > How do I register a GPIO for use in the PHY suspend and resume code?
> > Can it be handled outside of the PHY driver?
> 
> Nominally these days you should get a named GPIO using the
> GPIO descriptor abstraction, putting a named GPIO reference in the
> device tree node for the PHY, which should work fine
> if you're using device tree for this system.
> Documentation/gpio/consumer.txt
> 
> > If so how do ensure the appropriate suspend and resume sequencing?
> 
> AFAICT there is no good answer to this kind of questions. I guess
> my best answer would be something like what has been said for
> DRM drivers: handle all the sequence-sensitive hardware in one big
> composite driver and handle sequencing in the driver.
> 
> > For reference, we are using a Micrel KSZ8081 PHY connected to a
> > AT91SAMA5D35 processor.
> 
> I don't know how AT91 is progressing on the device tree side or if
> it's strictly required to boot these days. If it is, you should be able
> to proceed as indicated.

AT91 is fairly up to snuff on the device tree implementation.

> 
> > Addendum:
> > I ran into another situation where a GPIO enabled oscillator was used.
> > The oscillator in this case drives the master clock for a audio codec.
> > In the old days (before device tree), I could initialize the GPIO in the
> > platform board file. Now with device tree I can setup the pin multipler
> > but the initial state of the GPIO I am not sure how to set.
> 
> A driver needs to do this. Like a drivers/clk driver in this case I
> guess?
> 
> > Is there a way to directly change the state of a GPIO pin from a
> > devicetree entry?
> 
> I have suggested mechanisms like GPIO hogs to replace the need
> for very basic drivers that would just take a GPIO during init,
> set it and never do anything with it.
> 
> Like the gpiochip node should have some hog entries:
> 
> gpio-hog-high = <0>, <1>, <2>...;
> gpio-hog-low = <...>;
> 
> Then they would be taken away from other consumers and not
> possible to use for anything.
> 
> This has so far not been implemented though.

I was thinking less of a hog and more of an initial configuration.
Specifically for GPIO unregistered otherwise until exported via the GPIO
class.

> 
> Yours,
> Linus Walleij
