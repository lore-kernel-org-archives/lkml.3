Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaANQZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:25:01 -0500
Received: from c62.cesmail.net ([216.154.195.54]:17705 "EHLO c62.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaANQY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:24:58 -0500
Message-ID: <20140114112457.q54ujbz9c444s040-cebfxv@webmail.spamcop.net>
Date: Tue, 14 Jan 2014 11:24:57 -0500
From: Pavel Roskin <proski@gnu.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: serial8250: bogus low_latency destabilizes kernel, need sanity
	check
References: <20140113193547.47b7a646@IRBT4585>
	<20140114120811.648571ea@alan.etchedpixels.co.uk>
In-Reply-To: <20140114120811.648571ea@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Quoting One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:

>> Maybe we should unset the low_latency flag as soon as DMA fails?  There
>> are two flags, one is state->uart_port->flags and the other is
>> port->low_latency.  I guess we need to unset both.
>
> Well low latency and DMA are pretty much exclusive in the real world so
> probably DMA ports shouldn't allow low_latency to be set at all in DMA
> mode.

That's a useful insight.  I assumed exactly the opposite.

But how should a real low_latency device work?  Are they supported by  
8250_core?  Do they have hard IRQs?  Are those IRQs handled by  
serial8250_handle_irq()?

If DMA is not used, then serial8250_rx_chars() is the only way to  
receive data.  But serial8250_rx_chars() calls tty_flip_buffer_push()  
unconditionally, and the later should not be called from the IRQ  
context for low_latency devices, if the comment about it is to be  
trusted.

-- 
Regards,
Pavel Roskin
