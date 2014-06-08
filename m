Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaFHBKC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 21:10:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48929 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753142AbaFHBKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 21:10:00 -0400
Date: Sat, 7 Jun 2014 21:09:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1402180544.3979.3.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.1406072106360.6204-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2014, Benjamin Herrenschmidt wrote:

> Looking at the code a bit more ... that xhci_shutdown() worries me.
> 
> It basically just whacks xhci_halt() and optionally reset() but nothing
> is done that I can see to ensure that we aren't concurrently
> doing things like queuing URBs, polling the root hub etc...
> 
> That's definitely not clean and while it might work (most of the time
> at least) on actual shutdown it's definitely not right for kexec I
> reckon.

Yes, it really was meant for actual system shutdown.

> Now there's a separate discussion that we had a while ago and might
> want to resume which is to say that kexec shouldn't be calling
> shutdown() anyway, but instead remove() on all drivers which is
> a much better code path for the purpose of leaving the device in
> a state where a driver can reconnect to it.
> 
> However, in the case of XHCI that leads to another issue described
> here:
> 
> http://marc.info/?l=linux-usb&m=139483181809062&w=2
> 
> For which there was little / no discussion at all... I suppose we could
> do a quirk but I don't think the problem is fundamentally
> specific to the TI chip, we should probably stop both root hubs
> before we halt both HCDs.

The issue described in that email seems valid to me.  Maybe the patch
should be resubmitted.  Now that xhci-hcd has changed maintainership,
the discussion might move forward.

In any case, you certainly can try testing with that patch installed.  
After all, xhci-hcd should work properly after a rmmod/modprobe 
sequence, and this is pretty much the same thing.

Alan Stern

