Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaEGJ7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:59:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61720 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbaEGJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:59:16 -0400
Date: Wed, 7 May 2014 10:58:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140507095850.GC18456@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
 <20140506131234.GD30234@arm.com>
 <20140506150553.a12959fd71d83eddcb4b325d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506150553.a12959fd71d83eddcb4b325d@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:05:53PM +0100, Andrew Morton wrote:
> On Tue, 6 May 2014 14:12:34 +0100 Will Deacon <will.deacon@arm.com> wrote:
> > > > > My opinion is that when you are printing from each and every interrupt
> > > > > which happens so often, then you have a problem and disabling IRQs in
> > > > > printk so that your interrupt doesn't happen that often seems like a poor
> > > > > solution to me. You could as well just ratelimit your debug messages,
> > > > > couldn't you?
> > > > 
> > > > My use-case was basically using printk as a debug trace during early boot
> > > > when bringing up Linux on a new CPU core. I don't think ratelimiting would
> > > > be the right thing there, since I really did want as many messages to
> > > > reach the console as possible (which is also why I wrote this patch, not
> > > > just the other one in the series).
> > >   OK, I understand. It just seems wrong to me to throttle all interrupts on
> > > the cpu while doing printing just because someone might be doing debug
> > > printing from the interrupt. Sure it's fine as a debug hack but on a
> > > production machine that seems rather counterproductive.
> > 
> > Perhaps, but the one time I *really* want printk to be reliable is when I'm
> > using it to debug a problem.
> 
> If you're debugging a problem, you're able to alter printk!  So perhaps
> one way out of this is some developer-only ifdef to robustify printk
> for particular usage patterns.

Possibly, but I fear we'd incur the wrath of Alan after reading that other
thread. Having a CONFIG_ option or similar to control the amount of printing
we do is very similar to the command-line option Jan proposed in his series.

So, sadly, I think we may as well drop this patch for the time being. The
second patch in the series still applies fine without it and means we can
at least detect when we're dropping messages.

Will
