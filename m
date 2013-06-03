Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3FCViA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:38:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:37:55 -0400
Date: Mon, 3 Jun 2013 14:37:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Karthik Manamcheri <karthik.manamcheri@gmail.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linuxfoundation.org
Subject: Re: Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work
 correctly"
Message-ID: <20130603213754.GA15479@kroah.com>
References: <20130603133826.GE8270@merlin.infradead.org>
 <20130603165531.GA20412@kroah.com>
 <20130603170322.GF8270@merlin.infradead.org>
 <CAES2cWxYsxgjWzgNuhrWDoC7t2XrZQdeTe47ftWaCdg-2QoHUg@mail.gmail.com>
 <20130603203243.GC31705@kroah.com>
 <CAES2cWwPSpsqYdBHH51gVsCFdh_YVnADwzU+SKXqgzQwZMUVEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAES2cWwPSpsqYdBHH51gVsCFdh_YVnADwzU+SKXqgzQwZMUVEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:18:18PM -0500, Karthik Manamcheri wrote:
> On Mon, Jun 3, 2013 at 3:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 03, 2013 at 03:03:10PM -0500, Karthik Manamcheri wrote:
> > > > No worries, I undertand what Karthik is talking about, so I'll try to
> > > > figure this out.
> > > >
> > > > CONFIG_SERIAL_8250_NR_UARTS=32
> > > > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> > >
> > > The description for "CONFIG_SERIAL_8250_RUNTIME_UARTS" is "Set this to the
> > > maximum number of serial ports you want the kernel to register at boot
> time."
> > > Setting it to 4 means that you want to use 4 legacy ports! If you do not
> have
> > > any legacy UARTs, you are to set this to 0.
> > >
> > > >
> > > > is what was set in my .config, resulting in:
> > > >
> > > > [3.9.y]
> > > > 0: uart:16550A port:00001030 irq:16 tx:16522 rx:0 RTS|CTS|DTR|CD
> > > > 1: uart:unknown port:000002F8 irq:3
> > > > 2: uart:unknown port:000003E8 irq:4
> > > > 3: uart:unknown port:000002E8 irq:3
> > > >
> > > > [3.10-rc2]
> > > > 0: uart:unknown port:000003F8 irq:4
> > > > 1: uart:unknown port:000002F8 irq:3
> > > > 2: uart:unknown port:000003E8 irq:4
> > > > 3: uart:unknown port:000002E8 irq:3
> > > > 4: uart:16550A port:00001030 irq:16 tx:16226 rx:0 RTS|CTS|DTR|CD
> > >
> > > You have five ports because you set CONFIG_SERIAL_8250_RUNTIME_UARTS to 4
> and
> > > then you have to PCI port. This is exactly what my change addressed. We had
> > > issues with the ghost ports created in the system. In your case, if you set
> > > CONFIG_SERIAL_8250_RUNTIME_UARTS to 0, you'll have just one port which is
> the
> > > working available port.
> 
> 
> > But it is now named something differently, which is a regression, and we
> > can't have that, sorry.
> 
> It is named differently? Where? I am referring to https://git.kernel.org/cgit/
> linux/kernel/git/torvalds/linux.git/tree/drivers/tty/serial/8250/Kconfig
> 
> My change makes it work as it is in the description. This is not breaking
> anything except for asking users to use the correct config options.

Your change caused existing kernel configurations to act differently
than before, that's not ok, sorry.

Now you can argue that this was broken, but code trumps documentation
here, sorry.

greg k-h
