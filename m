Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbaGYNXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:23:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:47654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920AbaGYNW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:22:58 -0400
Date: Fri, 25 Jul 2014 15:22:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140725132256.GN20603@laptop.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop>
 <alpine.DEB.2.10.1407251135590.23352@nanos>
 <1805200.1exkRoNuC2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1805200.1exkRoNuC2@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:47:25PM +0200, Rafael J. Wysocki wrote:
> So it looks like we really need the "suspend" thing to either disable
> the interrupt entirely (in which case all handlers for all actions
> will not be invoked after it's been suspended) or leave it enabled
> (causing all handlers to be invoked all the time).
> 
> I'm not sure if we can do much beyond what's already in your tree
> about that, then.
> 
> Well, perhaps the patch failing the irq request in case of the
> IRQF_NO_SUSPEND mismatch is a bit too drastic.  Instead, we could
> just print a warning in __setup_irq() in that case and then check
> IRQF_NO_SUSPEND for all actions in __disable_irq().
> 
> What about this?

I suppose, not failing the request_irq allows the machine to boot and
mostly work, any funnies will be when the machine gets suspended.

And disabling suspend might be overkill because it might just all work
anyhow because the user didn't need that one particular wakeup source.

What a terrible mess this.

