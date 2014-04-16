Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaDPUDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:03:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47112 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbaDPUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:03:27 -0400
Date: Wed, 16 Apr 2014 21:00:51 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Paul Bolle <pebolle@tiscali.nl>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        James Cameron <quozl@laptop.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 12/21] serial: support for 16550A serial ports on
 LP-8x4x
Message-ID: <20140416210051.01bef49e@alan.etchedpixels.co.uk>
In-Reply-To: <c4533da6-30bd-4ea4-9011-a7e3b7258e62@email.android.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
	<1397668667-27328-1-git-send-email-ynvich@gmail.com>
	<1397668667-27328-6-git-send-email-ynvich@gmail.com>
	<20140416193532.0782f045@alan.etchedpixels.co.uk>
	<c4533da6-30bd-4ea4-9011-a7e3b7258e62@email.android.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 23:01:47 +0400
Sergei Ianovich <ynvich@gmail.com> wrote:

> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> +	baud = uart_get_baud_rate(port, termios, old,
> >> +				  port->uartclk / 16 / 0xffff,
> >> +				  port->uartclk / 16);
> >> +	switch (baud) {
> >> +	case 2400:
> >> +		len |= 1;
> >> +		break;
> >> +	case 4800:
> >> +		len |= 2;
> >> +		break;
> >> +	case 19200:
> >> +		len |= 4;
> >> +		break;
> >> +	case 38400:
> >> +		len |= 5;
> >> +		break;
> >> +	case 57600:
> >> +		len |= 6;
> >> +		break;
> >> +	case 115200:
> >> +		len |= 7;
> >> +		break;
> >> +	case 9600:
> >> +	default:
> >> +		len |= 3;
> >> +		break;
> >> +	};
> >
> >Some explanation of this would be useful - eg why is it set to 7 for
> >115200 baud and 3 for 115201 baud ?
> 
> I am not related to the device vendor in any way, so please take my answers for what they are worth.
> 
> It seems that there is not enough pins to properly connect the chips to the memory bus and just you the standard 8250 UART driver. Instead, clock divisor is set using this register.
> 
> So, if you know you're asking for (115200) you get it. If you don't or guess (115201), you get the default 9600.

Thats not quite what the code actually implements though.

> This is a policy, it may not be the right way to write a driver, but it is cheap and it works.

If thats how the hardware works and only supports a few fixed rates then
fine, but for default: you need to actually update he baudrate in the
passed termios struct so that the userspace knows its request was not
matched.

Take a look how the standard 8250 termios does it.

Also looking at this and some of the other serial bits I see no
dependencies on the problematic DMA driver, so does that mean you've got
a set of pieces that can be submitted anyway while the DMA driver
discussion continues ?

Alan
