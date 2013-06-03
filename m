Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab3FCRJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:09:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab3FCRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:09:49 -0400
Date: Mon, 3 Jun 2013 10:09:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-kernel@vger.kernel.org, karthik.manamcheri@gmail.com,
        torvalds@linuxfoundation.org
Subject: Re: Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work
 correctly"
Message-ID: <20130603170948.GA32694@kroah.com>
References: <20130603133826.GE8270@merlin.infradead.org>
 <20130603165531.GA20412@kroah.com>
 <20130603170322.GF8270@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603170322.GF8270@merlin.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:03:22PM -0400, Kyle McMartin wrote:
> On Mon, Jun 03, 2013 at 09:55:31AM -0700, Greg KH wrote:
> > On Mon, Jun 03, 2013 at 09:38:26AM -0400, Kyle McMartin wrote:
> > > This reverts commit cfcec52e9781f08948c6eb98198d65c45be75a70.
> > > 
> > > This regresses a longstanding behaviour on X86 systems, which end up with
> > > PCI serial ports moving between ttyS4 and ttyS0 when you bisect to opposite
> > > sides of this commit, resulting in the need to constantly modify the console
> > > setting in order to bisect across it.
> > > 
> > > Please revert, we can work on solving this for ARM platforms in a less
> > > disruptive way.
> > 
> > Ugh, how did this break x86 systems?  Karthik, you said this wouldn't
> > affect anyone else, what did you test it on?
> >
> > > Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
> > 
> > I'll go queue this up for the next -rc release, thanks Kyle.
> > 
> 
> No worries, I undertand what Karthik is talking about, so I'll try to
> figure this out.
> 
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> 
> is what was set in my .config, resulting in:
> 
> [3.9.y]
> 0: uart:16550A port:00001030 irq:16 tx:16522 rx:0 RTS|CTS|DTR|CD
> 1: uart:unknown port:000002F8 irq:3
> 2: uart:unknown port:000003E8 irq:4
> 3: uart:unknown port:000002E8 irq:3
> 
> [3.10-rc2]
> 0: uart:unknown port:000003F8 irq:4
> 1: uart:unknown port:000002F8 irq:3
> 2: uart:unknown port:000003E8 irq:4
> 3: uart:unknown port:000002E8 irq:3
> 4: uart:16550A port:00001030 irq:16 tx:16226 rx:0 RTS|CTS|DTR|CD

That's not good to have happen, so I'll do the revert.

> There's undeniably something wrong if RUNTIME_UARTS=0 doesn't result
> in his serial ports showing up, I'll try to help debug that, but I
> think the 3.9 behaviour is desireable if no "legacy" uarts are found.

I agree, it is.

thanks,

greg k-h
