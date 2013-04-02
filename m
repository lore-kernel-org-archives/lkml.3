Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab3DBMvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:51:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56928 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab3DBMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:51:43 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 2 Apr 2013 05:51:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@denx.de>
Cc: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dzu@denx.de
Subject: Re: UIO device tree bindings.
Message-ID: <20130402125149.GA7216@roeck-us.net>
References: <20130401142336.GA18034@amd.pavel.ucw.cz>
 <20130401154008.GA20963@amd.pavel.ucw.cz>
 <20130402024212.GA19431@roeck-us.net>
 <20130402115151.GA9052@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402115151.GA9052@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:51:51PM +0200, Pavel Machek wrote:
> On Mon 2013-04-01 19:42:12, Guenter Roeck wrote:
> > On Mon, Apr 01, 2013 at 05:40:08PM +0200, Pavel Machek wrote:
> > > On Mon 2013-04-01 16:23:36, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > I'd like to get uio device tree bindings to work -- with recent FPGA
> > > > parts it will be important. Latest version I see is 
> > > > 
> > > > https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073087.html
> > > > 
> > > > ... Is there anything newer?
> > > > 
> > > > I red the discussion, and main problem seems to be the "tell kernel to
> > > > drive this device tree device", right?
> > > 
> > Problem seems to be the notion that the proposed devicetree entry would not
> > describe the hardware, but its use. Not really sure I understand the problem,
> > as I would see the hardware description to be "A hardware device which is
> > compatible to and managed by the generic-uio driver". I would argue that
> > this _is_ a hardware description (if not, what is ?), but I am not the one
> > to make the call.
> 
> Well... one could argue that having "generic-uio" in board's device
> tree _is_ wrong, but having driver that binds to "generic-uio" is
> not. Hmm?
> 
You mean like "ata-generic" ?

> Or maybe we can do some magic with module parameter. That should be
> enough for expected use.
> 
I don't think that would make a difference. I mean, just take ns16550 as another
example. No one has problems declaring some block of hardware addresses to be
compatible with "ns16550", even though it can be anything including a memory
block on one of the FPGAs or ASICs we are talking about here, it can be anything
but a NS16550, and many of the actual "compatible" strings are not defined
anythere either.

So there is no problem with "ata-generic" and "ns16550", and no one cares if
"fsl,mpc8349emitx-pata" or "xlnx,xps-uart16550-2.00.b" is defined or not, but
"generic-uio" together with "ptx,c64fpga001" is unacceptable.

I think it has more to do with the uio driver not being an actual driver, but
the kernel part of a user-space driver, though that is just a wild guess.

Guenter
