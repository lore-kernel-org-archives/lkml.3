Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaEOGQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:16:09 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:11876 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbaEOGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:16:06 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-194.messagelabs.com!1400134561!11820583!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 15 May 2014 08:16:01 +0200
Date: Thu, 15 May 2014 08:15:55 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-serial@vger.kernel.org>
Subject: Re: linux-next: Tree for May 14 (tty/serial/men_z135_uart.c)
Message-ID: <20140515061555.GA13254@jtlinux>
References: <20140514182649.33e63e49@canb.auug.org.au>
 <53739A4E.2040009@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53739A4E.2040009@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 09:31:10AM -0700, Randy Dunlap wrote:
> On 05/14/2014 01:26 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20140513:
> >
>
> on x86_64:
>
> CONFIG_SERIAL_CORE=m
> but SERIAL_MEN_Z135=y.
>
> drivers/built-in.o: In function `men_z135_remove':
> men_z135_uart.c:(.text+0x5bc53): undefined reference to `uart_remove_one_port'
> drivers/built-in.o: In function `men_z135_set_termios':
> men_z135_uart.c:(.text+0x5c3b5): undefined reference to `uart_get_baud_rate'
> men_z135_uart.c:(.text+0x5c415): undefined reference to `uart_update_timeout'
> drivers/built-in.o: In function `men_z135_handle_tx':
> men_z135_uart.c:(.text+0x5c8f4): undefined reference to `uart_write_wakeup'
> drivers/built-in.o: In function `men_z135_intr':
> men_z135_uart.c:(.text+0x5ce28): undefined reference to `uart_handle_dcd_change'
> men_z135_uart.c:(.text+0x5ce51): undefined reference to `uart_handle_cts_change'
> drivers/built-in.o: In function `men_z135_probe':
> men_z135_uart.c:(.text+0x5cf96): undefined reference to `uart_add_one_port'
> drivers/built-in.o: In function `men_z135_init':
> men_z135_uart.c:(.init.text+0x26e9): undefined reference to `uart_register_driver'
> men_z135_uart.c:(.init.text+0x2766): undefined reference to `uart_unregister_driver'
> drivers/built-in.o: In function `men_z135_exit':
> men_z135_uart.c:(.exit.text+0xe4): undefined reference to `uart_unregister_driver'
> make[1]: *** [vmlinux] Error 1
>

Hi Randy,

There is a not yet merged patch from Arnd Bergmann, which can be found here:
https://lkml.org/lkml/2014/4/29/529

I've just checked and it resolves the problem at my place, can you please
verify it as well.

Thanks,
	Johannes
