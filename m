Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaGQIOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:14:07 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19463 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaGQIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:13:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RaHNqwoz2Equ/zsi3DETz
Date: Thu, 17 Jul 2014 01:12:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140717081232.GH18374@atomide.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
 <20140717070859.GD18374@atomide.com>
 <20140717074219.GA29193@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717074219.GA29193@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140717 00:44]:
> * Tony Lindgren | 2014-07-17 00:09:00 [-0700]:
> 
> >Seems to boot a bit further now with output from serial console
> >initially, then I'm getting the following error again that's probably
> >related to clocks not enabled when the registers are accessed:
> 
> It is (mostly) the same thing as before. We have additionally 
> omap_8250_startup() in the backtrace but it is the same thing.
> So you  say I miss a clock? Looking through serial8250_do_startup() I see:
> - pm_runtime_get_sync(port->dev); which should get the clocks up
> - serial8250_clear_fifos() which does a write at address + 8. Seems to 
>   work. 
> - serial_port_in(port, UART_LSR); does a read at address + 0x14, seems 
>   to work.
> - serial_port_in(port, UART_RX); does a read at address + 0. This is 
>   probably the bad one.

Hmm it could be that it works for a while because the clocks are on
from the bootloader and pm_runtime calls won't do anything. This
could happen if the interconnect data based on the ti,hwmods entry
is not getting matched to the new driver. This gets initialized when
the device entry gets created in omap_device_build_from_dt().

Or maybe something now affects the clock aliases? It seems that we
are still missing the clocks entries in the .dtsi files, see the
mappings with $ git grep uart drivers/clk/ti/
 
> Now comparing with omap-serial I noticed that I do a 32bit access
> instead a 16bit.
> Could you please try the following hack:

No change with that :) 
 
Regards,

Tony
