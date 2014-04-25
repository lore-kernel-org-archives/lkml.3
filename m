Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaDYOV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:21:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44265 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232AbaDYOVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:21:24 -0400
Date: Fri, 25 Apr 2014 15:20:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 1/2] printk: print initial logbuf contents before
 re-enabling interrupts
Message-ID: <20140425142056.GB12157@arm.com>
References: <1397734570-12748-1-git-send-email-will.deacon@arm.com>
 <20140425132937.GB10484@arm.com>
 <20140425140120.GG11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425140120.GG11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:01:20PM +0100, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 02:29:37PM +0100, Will Deacon wrote:
> > On Thu, Apr 17, 2014 at 12:36:09PM +0100, Will Deacon wrote:
> > > When running on a hideously slow system (~10Mhz FPGA) with a bunch of
> 
> Hey, still faster then the 4.77 MHz 8088 chips I started with :-)

... but you didn't have to run KVM guests on that sucker!

> > > debug printk invocations on the timer interrupt path, we end up filling
> > > the log buffer faster than we can drain it.
> > > 
> > > The reason is that console_unlock (which is responsible for moving
> > > messages out of logbuf to hand over to the console driver) removes one
> > > message at a time, briefly re-enabling interrupts between each of them.
> > > If the interrupt path prints more than a single message, then we can
> > > easily generate more messages than we can print for a regular, recurring
> > > interrupt (e.g. a 1khz timer). This results in messages getting silently
> > > dropped, leading to counter-intuitive, incomplete printk traces on the
> > > console.
> > > 
> > > Rather than run the console_unlock loop with interrupts disabled (which
> > > has obvious latency problems), this patch records the sequence number of
> > > the last message in the log buffer after taking the logbuf_lock. We can
> > > then print this fixed amount of work before re-enabling interrupts again,
> > > making sure we keep up with ourself. Other CPUs could still potentially
> > > flood the buffer, but there's little that we can do to protect against
> > > that.
> > 
> > Any thoughts on these two patches? I can understand the reluctance to make
> > changes to printk, but I had a horrible time debugging timers without these
> > patches!
> 
> They look fine to me.

Thanks, Peter. Andrew, would you mind taking these please? They look a bit
out of place in the arm64 tree.

I can repost them if necessary.

Cheers,

Will
