Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3HUXAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:00:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54042 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3HUXAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:00:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Date: Thu, 22 Aug 2013 01:11:14 +0200
Message-ID: <6438184.2yT2NMB1CE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130821160903.GA11908@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org> <CACRpkdaVz28gn-keUC4tTX+bdTKEV2ZrdHxshG=K3oM_NhvroA@mail.gmail.com> <20130821160903.GA11908@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 21, 2013 05:09:03 PM Matthew Garrett wrote:
> On Wed, Aug 21, 2013 at 05:57:07PM +0200, Linus Walleij wrote:
> 
> > - The I2C address is specified in "reg" - maybe ACPI have
> >   some other way to assign I2C addresses to I2C devices?
> >   In any case, it *must* reference the parent I2C controller,
> >   here that is done implicitly by placing this DT node inside
> >   the I2C controllers DT node.
> 
> That's fine. You put the child device inside the I2C contorller's scope, 
> which can be done from a separate ACPI table if you want. The address 
> can be provided via _ADR().
> 
> > - Then it is using a GPIO line as interrupt, and specify that
> >   this shall be configured as a falling edge IRQ.
> 
> ACPI 5 permits this.
> 
> > - It then tells the interrupt controller parent. So it needs
> >   to have a reference to whatever interrupt chip device
> >   will handle that IRQ.
> 
> By interrupt controller, do you mean the GPIO controller? ACPI GPIO 
> definitions include the parent device.
> 
> > - Further it *is* an interrupt controller, so devices connected
> >   to the GPIO lines may generate IRQs and then this
> >   device should service them. Is it possible that the devices
> >   connected to this expander in turn use ACPI to describe
> >   themselves? Then we need a reference in the other
> >   direction.
> 
> I think that's also doable.
> 
> > - Further it is a wakeup source, so each IRQ it provides
> >   on its GPIO lines can be set as a wakeup. I wonder how
> >   this plays with D-states and ACPI.
> 
> That's fine. GPIO lines can be described as causing ACPI events and then 
> that simply referenced as a wakeup event.
> 
> > I did present the above as an extreme example, but if we
> > start to combine DT and ACPI we have to have that kind of
> > hardware in mind. GPIO expanders with IRQs and all are
> > maybe rare on desktops and laptops but very common on
> > embedded systems.
> 
> Yeah, describing complicated device topology isn't really the problem I 
> think we'll end up facing - it's the wider range of device configuration 
> data that worries me.

There are at least two problems here in my view.  The above is the first one.

The second one is that even if there is a *theoretical* way to represent
the configuration information from a Device Tree in ACPI tables, there still
is the question who will be responsible for creating those ACPI tables for
the given system in the first place.  That would involve writing ASL code,
compiling it into AML, possibly verifying that it does what it's supposed to
do etc.  And it obviously has to match the rest of the ACPI namespace.

To me, there's quite a difference between saying "this can be done" and giving
instructions how to do it.

Moreover, even if we are able to instruct everyone interested how to create
the requisite ACPI tables, there is the little problem of shipping them
somehow so that they actually can be used by the kernel that needs to be
addressed too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
