Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaJ2Tu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:50:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbaJ2Tu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:50:58 -0400
Date: Wed, 29 Oct 2014 20:50:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on
 linux-next
Message-ID: <20141029195054.GH10501@worktop.programming.kicks-ass.net>
References: <20141029155620.GA4886@kria>
 <20141029180734.GQ12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410291918060.5308@nanos>
 <20141029193603.GS12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410292046270.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410292046270.5308@nanos>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:49:03PM +0100, Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, Peter Zijlstra wrote:
> 
> > On Wed, Oct 29, 2014 at 07:33:00PM +0100, Thomas Gleixner wrote:
> > > Yuck. No. You are just papering over the problem.
> > > 
> > > What happens if you add 'threadirqs' to the kernel command line? Or if
> > > the interrupt line is shared with a real threaded interrupt user?
> > > 
> > > The proper solution is to have a poll_lock for e1000 which serializes
> > > the hardware interrupt against netpoll instead of using
> > > disable/enable_irq().
> > > 
> > > In fact that's less expensive than the disable/enable_irq() dance and
> > > the chance of contention is pretty low. If done right it will be a
> > > NOOP for the CONFIG_NET_POLL_CONTROLLER=n case.
> > > 
> > 
> > OK a little something like so then I suppose.. But I suspect most all
> > the network drivers will need this and maybe more, disable_irq() is a
> > popular little thing and we 'just' changed semantics on them.
> 
> We changed that almost 4 years ago :) What we 'just' did was to add a
> prominent warning into the code.

You know that is the same right... they didn't know it was broken
therefore it wasn't :-), but now they need to go actually do stuff about
it, an entirely different proposition.
