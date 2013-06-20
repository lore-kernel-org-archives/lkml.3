Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161282Ab3FTRTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:19:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55198 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161068Ab3FTRTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:19:32 -0400
Date: Thu, 20 Jun 2013 13:19:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, <balbi@ti.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/6] Suspend USB Host controller on bus suspend
In-Reply-To: <51C2F807.1000301@ti.com>
Message-ID: <Pine.LNX.4.44L0.1306201314160.2063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Roger Quadros wrote:

> >> As the omap-ehci controller driver needs to do some additional work to put
> >> itself into suspend/resume and make sure it is resumed to process an interrupt,
> >> we need to be able to override irq, bus_suspend, and bus_resume handlers. This
> >> provision is done in patch 3.
> > 
> > Do you still need to override these things if you do the controller
> > suspend at the right time?
> > 
> 
> At least not for bus_suspend and bus_resume. We will still need to override the irq
> handler though. But, if we can take care of this generically in the ehci_irq handler (i.e. make
> sure controller is not suspended while accessing it) then we don't need such override
> for irq.

I don't think you need to override anything.  The high-level interrupt
handler usb_hcd_irq() will avoid calling ehci_irq() when the
HCD_HW_ACCESSIBLE flag isn't set.  All you will need to do in
ehci-omap.c is call synchronize_irq() after ehci_suspend() returns and
before turning off the clocks.

Alan Stern

