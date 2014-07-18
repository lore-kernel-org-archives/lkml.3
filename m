Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbaGRG0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:26:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31945 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaGRG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:26:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+H+q4b4QEc92RURl+pJTHh
Date: Thu, 17 Jul 2014 23:24:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140718062456.GJ18374@atomide.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
 <20140717070859.GD18374@atomide.com>
 <20140717074219.GA29193@linutronix.de>
 <20140717081232.GH18374@atomide.com>
 <53C7A01C.50107@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C7A01C.50107@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140717 03:09]:
> On 07/17/2014 10:12 AM, Tony Lindgren wrote:
> > Hmm it could be that it works for a while because the clocks are on
> > from the bootloader and pm_runtime calls won't do anything. This
> > could happen if the interconnect data based on the ti,hwmods entry
> > is not getting matched to the new driver. This gets initialized when
> > the device entry gets created in omap_device_build_from_dt().
> > 
> > Or maybe something now affects the clock aliases? It seems that we
> > are still missing the clocks entries in the .dtsi files, see the
> > mappings with $ git grep uart drivers/clk/ti/
> 
> I've been looking for something completely different while I noticed
> this:
> 
> in drivers/tty/serial/omap-serial.c
> | static struct platform_driver serial_omap_driver = {
> |         .driver         = {
> |                 .name   = DRIVER_NAME,
> |         },
> | };
> |
> 
> and DRIVER_NAME should come from include/linux/platform_data/serial-omap.h
> Looking further, I've found arch/arm/mach-omap2/serial.c:
> | void __init omap_serial_init_port(struct omap_board_data *bdata,
> |                         struct omap_uart_port_info *info)
> | {
> |         char *name
> …
> |	name = DRIVER_NAME;
> …
> |	pdev = omap_device_build(name, uart->num, oh, pdata, pdata_size);
> …
> |
> 
> Would this explain it?

That would explain it for legacy booting, but not for device tree
based booting. I can try to debug it further on Monday.

Regards,

Tony
