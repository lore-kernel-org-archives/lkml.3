Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3FCUct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:32:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:32:44 -0400
Date: Mon, 3 Jun 2013 13:32:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Karthik Manamcheri <karthik.manamcheri@gmail.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linuxfoundation.org
Subject: Re: Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work
 correctly"
Message-ID: <20130603203243.GC31705@kroah.com>
References: <20130603133826.GE8270@merlin.infradead.org>
 <20130603165531.GA20412@kroah.com>
 <20130603170322.GF8270@merlin.infradead.org>
 <CAES2cWxYsxgjWzgNuhrWDoC7t2XrZQdeTe47ftWaCdg-2QoHUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAES2cWxYsxgjWzgNuhrWDoC7t2XrZQdeTe47ftWaCdg-2QoHUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:03:10PM -0500, Karthik Manamcheri wrote:
> > No worries, I undertand what Karthik is talking about, so I'll try to
> > figure this out.
> >
> > CONFIG_SERIAL_8250_NR_UARTS=32
> > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> 
> The description for "CONFIG_SERIAL_8250_RUNTIME_UARTS" is "Set this to the
> maximum number of serial ports you want the kernel to register at boot time."
> Setting it to 4 means that you want to use 4 legacy ports! If you do not have
> any legacy UARTs, you are to set this to 0.
> 
> >
> > is what was set in my .config, resulting in:
> >
> > [3.9.y]
> > 0: uart:16550A port:00001030 irq:16 tx:16522 rx:0 RTS|CTS|DTR|CD
> > 1: uart:unknown port:000002F8 irq:3
> > 2: uart:unknown port:000003E8 irq:4
> > 3: uart:unknown port:000002E8 irq:3
> >
> > [3.10-rc2]
> > 0: uart:unknown port:000003F8 irq:4
> > 1: uart:unknown port:000002F8 irq:3
> > 2: uart:unknown port:000003E8 irq:4
> > 3: uart:unknown port:000002E8 irq:3
> > 4: uart:16550A port:00001030 irq:16 tx:16226 rx:0 RTS|CTS|DTR|CD
> 
> You have five ports because you set CONFIG_SERIAL_8250_RUNTIME_UARTS to 4 and
> then you have to PCI port. This is exactly what my change addressed. We had
> issues with the ghost ports created in the system. In your case, if you set
> CONFIG_SERIAL_8250_RUNTIME_UARTS to 0, you'll have just one port which is the
> working available port.

But it is now named something differently, which is a regression, and we
can't have that, sorry.

thanks,

greg k-h
