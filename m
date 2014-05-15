Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaEOQvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37353 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaEOQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:39 -0400
Message-ID: <5374F095.3090107@infradead.org>
Date: Thu, 15 May 2014 09:51:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: Re: linux-next: Tree for May 14 (tty/serial/men_z135_uart.c)
References: <20140514182649.33e63e49@canb.auug.org.au> <53739A4E.2040009@infradead.org> <20140515061555.GA13254@jtlinux>
In-Reply-To: <20140515061555.GA13254@jtlinux>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 11:15 PM, Johannes Thumshirn wrote:
> On Wed, May 14, 2014 at 09:31:10AM -0700, Randy Dunlap wrote:
>> On 05/14/2014 01:26 AM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20140513:
>>>
>>
>> on x86_64:
>>
>> CONFIG_SERIAL_CORE=m
>> but SERIAL_MEN_Z135=y.
>>
>> drivers/built-in.o: In function `men_z135_remove':
>> men_z135_uart.c:(.text+0x5bc53): undefined reference to `uart_remove_one_port'
>> drivers/built-in.o: In function `men_z135_set_termios':
>> men_z135_uart.c:(.text+0x5c3b5): undefined reference to `uart_get_baud_rate'
>> men_z135_uart.c:(.text+0x5c415): undefined reference to `uart_update_timeout'
>> drivers/built-in.o: In function `men_z135_handle_tx':
>> men_z135_uart.c:(.text+0x5c8f4): undefined reference to `uart_write_wakeup'
>> drivers/built-in.o: In function `men_z135_intr':
>> men_z135_uart.c:(.text+0x5ce28): undefined reference to `uart_handle_dcd_change'
>> men_z135_uart.c:(.text+0x5ce51): undefined reference to `uart_handle_cts_change'
>> drivers/built-in.o: In function `men_z135_probe':
>> men_z135_uart.c:(.text+0x5cf96): undefined reference to `uart_add_one_port'
>> drivers/built-in.o: In function `men_z135_init':
>> men_z135_uart.c:(.init.text+0x26e9): undefined reference to `uart_register_driver'
>> men_z135_uart.c:(.init.text+0x2766): undefined reference to `uart_unregister_driver'
>> drivers/built-in.o: In function `men_z135_exit':
>> men_z135_uart.c:(.exit.text+0xe4): undefined reference to `uart_unregister_driver'
>> make[1]: *** [vmlinux] Error 1
>>
> 
> Hi Randy,
> 
> There is a not yet merged patch from Arnd Bergmann, which can be found here:
> https://lkml.org/lkml/2014/4/29/529
> 
> I've just checked and it resolves the problem at my place, can you please
> verify it as well.

Yes, that works for me also.  Thanks.

-- 
~Randy
