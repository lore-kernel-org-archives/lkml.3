Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaFGIQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:16:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:53537 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbaFGIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:16:13 -0400
Message-ID: <1402128942.3247.292.camel@pasglop>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com
Date: Sat, 07 Jun 2014 18:15:42 +1000
In-Reply-To: <1397588067.21321.11.camel@vger.seibold.net>
References: <1397416959.1555.30.camel@vger.seibold.net>
	 <1397468521.9258.28.camel@pasglop>
	 <20140414174458.Horde.ieyRX8PcZ0lg3nY1QFE2DA4@webmail.your-server.de>
	 <20140414214807.GA32141@oc0268524204.ibm.com>
	 <20140415120417.Horde.2gdC8Woe64OQXOq_cVqtkg6@webmail.your-server.de>
	 <20140415122013.GA21101@oc0268524204.ibm.com>
	 <20140415170028.Horde.ojJX1pFPqNqnig4r08hUkg1@webmail.your-server.de>
	 <20140415183345.GC21101@oc0268524204.ibm.com>
	 <1397587378.21321.2.camel@vger.seibold.net>
	 <20140415184941.GD21101@oc0268524204.ibm.com>
	 <1397588067.21321.11.camel@vger.seibold.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 20:54 +0200, Stefani Seibold wrote:

> > > > > >>>>[    1.170029] xhci_hcd 0001:03:00.0: xHCI Host Controller
> > > > > >>>>[    1.175306] xhci_hcd 0001:03:00.0: new USB bus registered,
> > > > > >>>>assigned bus number 1
> > > > > >>>>[    1.212561] xhci_hcd 0001:03:00.0: Host not halted after 16000
> > > > > >>>>microseconds.
> > > > > >>>>[    1.219621] xhci_hcd 0001:03:00.0: can't setup: -110
> > > > > >>>>[    1.224597] xhci_hcd 0001:03:00.0: USB bus 1 deregistered
> > > > > >>>>[    1.230021] xhci_hcd 0001:03:00.0: init 0001:03:00.0 fail, -110
> > > > > >>>>[    1.235955] xhci_hcd: probe of 0001:03:00.0 failed with error -110
> > > > > >>>>

Cascardo, Alan,

Bringing back that old thread..

I'm trying to kexec from our OPAL FW bootloader (3.10.23 based) to a
fedora 3.14.3 on a new machine and am still seeing the above.

A reset brings the chip back.

Do we have any resolution here ? It looks like the xHCI remains active
on the way out and is clagged up on the way back in, at least in a
state the driver really doesn't like.

And this is a "clean" kexec, not a forced one... This is killing USB on
the upcoming OpenPower dev machines.

Cheers,
Ben.


