Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaGQKHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:07:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:34503 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaGQKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:06:58 -0400
Message-ID: <53C7A01C.50107@linutronix.de>
Date: Thu, 17 Jul 2014 12:06:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-6-git-send-email-bigeasy@linutronix.de> <20140717070859.GD18374@atomide.com> <20140717074219.GA29193@linutronix.de> <20140717081232.GH18374@atomide.com>
In-Reply-To: <20140717081232.GH18374@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:12 AM, Tony Lindgren wrote:
> Hmm it could be that it works for a while because the clocks are on
> from the bootloader and pm_runtime calls won't do anything. This
> could happen if the interconnect data based on the ti,hwmods entry
> is not getting matched to the new driver. This gets initialized when
> the device entry gets created in omap_device_build_from_dt().
> 
> Or maybe something now affects the clock aliases? It seems that we
> are still missing the clocks entries in the .dtsi files, see the
> mappings with $ git grep uart drivers/clk/ti/

I've been looking for something completely different while I noticed
this:

in drivers/tty/serial/omap-serial.c
| static struct platform_driver serial_omap_driver = {
|         .driver         = {
|                 .name   = DRIVER_NAME,
|         },
| };
|

and DRIVER_NAME should come from include/linux/platform_data/serial-omap.h
Looking further, I've found arch/arm/mach-omap2/serial.c:
| void __init omap_serial_init_port(struct omap_board_data *bdata,
|                         struct omap_uart_port_info *info)
| {
|         char *name
…
|	name = DRIVER_NAME;
…
|	pdev = omap_device_build(name, uart->num, oh, pdata, pdata_size);
…
|

Would this explain it?

> Regards,
> 
> Tony

Sebastian
