Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab3IHAwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 20:52:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53176 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3IHAwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 20:52:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522BCA33.6000701@roeck-us.net>
Date: Sat, 07 Sep 2013 17:52:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: Daniel Santos <danielfsantos@att.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net>
In-Reply-To: <522BC27A.5080303@att.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 05:19 PM, Daniel Santos wrote:
> I've posted a number of requests for aid on this and have gotten very little responses and none that were helpful. I have spent at least 24 hours of research time on this and just a little direction from somebody who knows this subsystem can help me immensely as the IRQ subsystem is new to me.
>
> This is for the MCP2210 driver (a USB to SPI/GPIO bridge) and my driver is the first of its class for the Linux kernel, giving me less to look at as an example.  I intend to use standard drivers for whatever I have connected at the other end.  For this to work, I need to supply interrupts for some of these drivers to work correctly.  How do I do this? Every thing else on this driver is ready to go and my handler functions for this are empty and waiting for some code.
>
Not really. Have a look at https://github.com/groeck/diolan even though the SPI part there
still isn't working and it is far from being acceptable upstream in its current form.
It also doesn't support interrupts.

It is modeled as mfd driver, which I think you might want to consider as well.

> So do i create an IRQ domain and then call generic_handle_irq() from my URB complete() function? If so, which type of IRQ Domain is appropriate for this? Unlike typical platform devices, these are dynamically added and removed throughout the life of the kernel, adding to the challenge. So, if I understand correctly, my base IRQ number needs to be dynamically generated.  How should I manage this?
>
> Finally, if you have any example drivers that are doing something similar, that would be SO very helpful as well!
>
There are several drivers in drivers/mfd solving the same problem, ie using
irq domains to pass interrupts to client drivers. Look for irq_domain_add_simple().
drivers/mfd/tc3589x.c seems to be a good example.

> I have some secondary (and less important) questions about how to integrate this with device drivers that want a DT / open firmware config (which I know almost nothing about at this time), but that can wait.
>
If you look into the mfd subsystem, you may notice that it handles at least some of the complexity
of interrupt handling as well as devicetree integration. One more reason to use it.

Guenter

> Any help *greatly* appreciated and thank you in advance!
>
> Daniel
>
> PS: If interested, my current driver here: https://github.com/daniel-santos/mcp2210-linux. I  haven't sought review yet because I want to finish it first.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>

