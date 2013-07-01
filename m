Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3GAVBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:01:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38619 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754901Ab3GAVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:01:28 -0400
Date: Mon, 1 Jul 2013 17:01:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <20130701164920.GA31370@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1307011655580.1547-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Felipe Balbi wrote:

> > I don't know what Pad wakeup is.  The wakeup signal has to originate 
> > from the EHCI controller, doesn't it?  If not, how does the Pad know 
> > when a wakeup is needed?
> 
> That's really an OMAP thing, I guess. Pad wakeup sits in the PRCM (IIRC)
> inside and always on power domain. EHCI sits in another power domain
> which be turned off. When it's turned off (power gated and clock gated)
> the EHCI block has no means to wakeup whatsoever. That's when pad wakeup
> comes into play. It is generated when PRCM sees a change in the actual
> pad of the die. To check who should 'own' the wakeup, it checks the
> muxing settings to verify whose pad is that.

How does the PRCM know which changes should generate wakeup events?  
In the EHCI controller, this is managed by the settings of the WKOC_E,
WKDSCNNT_E, and WKCNNT_E bits in the PORTSC registers.  But if EHCI is
powered off, those bits can't be used.

Also, once the wakeup signal has been turned on, how does it get turned 
off again?

Alan Stern

