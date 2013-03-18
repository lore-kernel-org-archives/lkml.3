Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3CROQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:16:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751986Ab3CROQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:16:57 -0400
Date: Mon, 18 Mar 2013 10:16:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Yuan-Hsin Chen <yuanlmm@gmail.com>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <Julia.Lawall@lip6.fr>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
In-Reply-To: <20130318101854.GQ17135@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1303181010540.1922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Felipe Balbi wrote:

> On Mon, Mar 18, 2013 at 06:06:18PM +0800, Yuan-Hsin Chen wrote:
> > Hi,
> > 
> > I tried to modify fusbh200 hcd driver following ehci-platform.c.
> > However, the register definition of fusbh200 is partially incompatible
> > to ehci. For fusbh200, only the elements between "command" and
> > "async_next" in struct ehci_regs are consistent with ehci which means

What about the port_status registers?  They're not between command and
async_next.  If they aren't consistent with EHCI, it makes things a lot
more complicated.

> > it would cause copious modification and duplication of ehci hcd
> > driver. For example, there is no "configured_flag" register in
> > fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
> > in function ehci_run which would cause compile errors. Therefore,
> > maybe my first patch which refers to oxu210hp-hcd is a better
> > solution?
> 
> why don't you just add a quirk flag to ehci struct so that it knows it
> shouldn't access CONFIGFLAG register when that's non-existent ?
> 
> There are only 5 uses of configured_flag in ehci-hcd.c, so it should be
> easy to wrap that around a flag check.

Two of those uses turn configured_flag on and two of them turn it off.  
However, one of the uses tests its value (the first one in
ehci_resume).  How would that be handled if configured_flag doesn't
exist?

> Alan, would you have a better idea ? Looks like this is a non-standard
> EHCI implementation.

Yes, it does.  If all we need is to protect four or five accesses with 
a quirk flag, that's okay with me.

Alan Stern

