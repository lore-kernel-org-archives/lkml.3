Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaE1RhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:37:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48722 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751550AbaE1RhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:37:21 -0400
Date: Wed, 28 May 2014 13:37:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is
 in use
Message-ID: <20140528133718.160a4754@gandalf.local.home>
In-Reply-To: <20140528172239.GX30445@twins.programming.kicks-ass.net>
References: <20140528131440.2283213c@gandalf.local.home>
	<20140528172239.GX30445@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 19:22:39 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, May 28, 2014 at 01:14:40PM -0400, Steven Rostedt wrote:
> > 
> > trace_printk() is used to debug fast paths within the kernel. Places
> > that gets called in any context (interrupt or NMI) or thousands of
> > times a second. Something you do not want to do with a printk().
> > 
> > In order to make it completely lockless as it needs a temporary buffer
> > to handle some of the string formatting, a page is created per cpu for
> > every context (four per cpu; normal, softirq, irq, NMI).
> > 
> > Since trace_printk() should only be used for debugging purposes,
> > there's no reason to waste memory on these buffers on a production
> > system. That means, trace_printk() should never be used unless a
> > developer is debugging their kernel. There's macro magic to allocate
> > the buffers if trace_printk() is used anywhere in the kernel.
> > 
> > To help enforce that trace_printk() isn't used outside of development,
> > when it is used, a nasty banner is displayed on bootup (or when a module
> > is loaded that uses trace_printk() and the kernel core does not).
> > 
> > Here's the banner:
> > 
> >  ****************************************
> >  ** NOTICE NOTICE NOTICE NOTICE NOTICE **
> >  ** trace_printk() being used.         **
> >  ** Allocating extra memory for it     **
> >  ****************************************
> > 
> > Hmm, maybe I should add "Not for production use" to scare people even
> > more?
> 
> Does that really stop people from doing stupid? Wouldn't it be better to

Scary banners usually do. Perhaps this isn't scary enough.

> make sure nobody merges a trace_printk() user in mainline? You can set
> up a commit hook and check for +.*trace_printk or so.

Of course, but that requires me to monitory it. It may be too late when
I notice it.

Nothing prevents me from doing both :-)

-- Steve
