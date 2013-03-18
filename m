Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3CRSrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:47:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753542Ab3CRSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:47:18 -0400
Date: Mon, 18 Mar 2013 14:47:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Yuan-Hsin Chen <yuanlmm@gmail.com>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <Julia.Lawall@lip6.fr>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
In-Reply-To: <20130318182316.GA13371@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1303181444330.1922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Felipe Balbi wrote:

> Hi,
> 
> On Mon, Mar 18, 2013 at 10:16:56AM -0400, Alan Stern wrote:
> > > > it would cause copious modification and duplication of ehci hcd
> > > > driver. For example, there is no "configured_flag" register in
> > > > fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
> > > > in function ehci_run which would cause compile errors. Therefore,
> > > > maybe my first patch which refers to oxu210hp-hcd is a better
> > > > solution?
> > > 
> > > why don't you just add a quirk flag to ehci struct so that it knows it
> > > shouldn't access CONFIGFLAG register when that's non-existent ?
> > > 
> > > There are only 5 uses of configured_flag in ehci-hcd.c, so it should be
> > > easy to wrap that around a flag check.
> > 
> > Two of those uses turn configured_flag on and two of them turn it off.  
> > However, one of the uses tests its value (the first one in
> > ehci_resume).  How would that be handled if configured_flag doesn't
> > exist?
> 
> perhaps they don't use it because they have a root-hub TT ? In that case
> you assume EHCI *always* owns the port. Would that work ?

The usage in ehci_resume is meant for checking whether power was lost 
while the controller was suspended.  This probably isn't an issue 
during runtime suspend; it's likely to come up only during system 
suspend.  If Yuan-Hsin's platform doesn't support system suspend then 
we don't have to worry about it.

Alan Stern

