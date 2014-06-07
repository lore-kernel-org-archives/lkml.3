Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaFGPkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 11:40:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60691 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752821AbaFGPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 11:40:17 -0400
Date: Sat, 7 Jun 2014 11:40:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1402128942.3247.292.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.1406071133090.31120-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Mathias  to CC: list]

On Sat, 7 Jun 2014, Benjamin Herrenschmidt wrote:

> I'm trying to kexec from our OPAL FW bootloader (3.10.23 based) to a
> fedora 3.14.3 on a new machine and am still seeing the above.
> 
> A reset brings the chip back.
> 
> Do we have any resolution here ? It looks like the xHCI remains active
> on the way out and is clagged up on the way back in, at least in a
> state the driver really doesn't like.
> 
> And this is a "clean" kexec, not a forced one... This is killing USB on
> the upcoming OpenPower dev machines.

The current xhci-hcd driver includes a quirk flag (XHCI_SPURIOS_WAKEUP) 
that causes the shutdown routine to reset the controller.  It wasn't 
meant for fixing kexec problems, but I bet you could use it for that 
purpose.

In addition, it's possible that a reset is needed in the probe pathway.

Alan Stern

