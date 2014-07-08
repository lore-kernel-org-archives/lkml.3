Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaGHVNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:13:09 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50165 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaGHVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:13:08 -0400
Date: Tue, 8 Jul 2014 14:12:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] GPIO button wth wakeup attribute is supposed to wake the
 system up
Message-ID: <20140708211259.GA26792@core.coreip.homeip.net>
References: <53A2340D.9030503@linux.intel.com>
 <13019301.98tkdHyOVf@vostro.rjw.lan>
 <20140708204530.GA23908@core.coreip.homeip.net>
 <2962778.H1VBlZAtS4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2962778.H1VBlZAtS4@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:06:17PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 08, 2014 01:45:30 PM Dmitry Torokhov wrote:
> > On Tue, Jul 08, 2014 at 10:52:52PM +0200, Rafael J. Wysocki wrote:
> > > On Thursday, June 19, 2014 08:51:25 AM Li, Aubrey wrote:
> > > > When the wakeup attribute is set, the GPIO button is capable of
> > > > waking up the system from sleep states, including the "freeze"
> > > > sleep state.  For that to work, its driver needs to pass the
> > > > IRQF_NO_SUSPEND flag to devm_request_any_context_irq(), or the
> > > > interrupt will be disabled by suspend_device_irqs() and the
> > > > system won't be woken up by it from the "freeze" sleep state.
> > > > 
> > > > The suspend_device_irqs() routine is a workaround for drivers
> > > > that mishandle interrupts triggered when the devices handled
> > > > by them are suspended, so it is safe to use IRQF_NO_SUSPEND in
> > > > all drivers that don't have that problem.
> > > > 
> > > > The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.
> > > > 
> > > > Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
> > > > Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > OK
> > > 
> > > Due to the lack of response (ie. no objections) and because the issue
> > > addressed by this patch is real, I'm queuing it up as a PM-related fix
> > > for 3.17.
> > 
> > Please do not. The response is till the same: board code should make sure
> > that enable_irq_wake() does the right thing and keeps interrupts enabled.
> 
> Which board code?  That's nothing like that for the platforms in question.

Then it needs to be written.

> 
> > It is wrong to patch drivers for this.
> 
> Why is it?  Only drivers know if they can handle incoming interrupts after
> having suspended their devices.

The driver correctly used enable_irq_wake() to indicate that interrupt should
be a wakeup source, the now the core/board needs to make sure the interrupt
gets delivered to the driver properly. We should not be patching every driver
that uses enable_irq_wake() with IRQF_NO_SUSPEND. If you look at the earlier
patch discussion Tegra folks managed to implement this behavior just fine.

Thanks.

-- 
Dmitry
