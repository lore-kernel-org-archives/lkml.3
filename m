Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3HUQJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:09:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54613 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3HUQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:09:07 -0400
Date: Wed, 21 Aug 2013 17:09:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130821160903.GA11908@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org>
 <2276651.WHL3SkvOZi@vostro.rjw.lan>
 <CACRpkdaVz28gn-keUC4tTX+bdTKEV2ZrdHxshG=K3oM_NhvroA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaVz28gn-keUC4tTX+bdTKEV2ZrdHxshG=K3oM_NhvroA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:57:07PM +0200, Linus Walleij wrote:

> - The I2C address is specified in "reg" - maybe ACPI have
>   some other way to assign I2C addresses to I2C devices?
>   In any case, it *must* reference the parent I2C controller,
>   here that is done implicitly by placing this DT node inside
>   the I2C controllers DT node.

That's fine. You put the child device inside the I2C contorller's scope, 
which can be done from a separate ACPI table if you want. The address 
can be provided via _ADR().

> - Then it is using a GPIO line as interrupt, and specify that
>   this shall be configured as a falling edge IRQ.

ACPI 5 permits this.

> - It then tells the interrupt controller parent. So it needs
>   to have a reference to whatever interrupt chip device
>   will handle that IRQ.

By interrupt controller, do you mean the GPIO controller? ACPI GPIO 
definitions include the parent device.

> - Further it *is* an interrupt controller, so devices connected
>   to the GPIO lines may generate IRQs and then this
>   device should service them. Is it possible that the devices
>   connected to this expander in turn use ACPI to describe
>   themselves? Then we need a reference in the other
>   direction.

I think that's also doable.

> - Further it is a wakeup source, so each IRQ it provides
>   on its GPIO lines can be set as a wakeup. I wonder how
>   this plays with D-states and ACPI.

That's fine. GPIO lines can be described as causing ACPI events and then 
that simply referenced as a wakeup event.

> I did present the above as an extreme example, but if we
> start to combine DT and ACPI we have to have that kind of
> hardware in mind. GPIO expanders with IRQs and all are
> maybe rare on desktops and laptops but very common on
> embedded systems.

Yeah, describing complicated device topology isn't really the problem I 
think we'll end up facing - it's the wider range of device configuration 
data that worries me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
