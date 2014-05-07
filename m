Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaEGJqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:46:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61006 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbaEGJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:46:51 -0400
Date: Wed, 7 May 2014 10:46:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jan Kara <jack@suse.cz>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140507094623.GB18456@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
 <20140506131234.GD30234@arm.com>
 <20140506140032.GA22739@quack.suse.cz>
 <20140506150036.GJ30234@arm.com>
 <20140506200022.GB27469@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506200022.GB27469@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 09:00:22PM +0100, Jan Kara wrote:
> On Tue 06-05-14 16:00:37, Will Deacon wrote:
> > On Tue, May 06, 2014 at 03:00:32PM +0100, Jan Kara wrote:
> > > On Tue 06-05-14 14:12:34, Will Deacon wrote:
> > > > Right, so there's the usual compromise here between throughput and latency.
> > >   I'd see that compromise if enabling & disabling interrupts would be
> > > taking considerable amount of time. I don't think that was your concern,
> > > was it? Maybe I just misunderstood you...
> > 
> > Well, that isn't the quickest operation on ARM (since it's
> > self-synchronising), but I was actually referring to the ability to drain
> > the log buffer (with interrupts disabled) vs the ability to service
> > interrupts quickly. The moment we re-enable interrupts, we can start adding
> > more messages to the buffer from the IRQ path (I didn't attempt to solve the
> > multi-CPU case, as I mentioned before).
>   I see. But practically the multi-CPU case is much more common than the
> IRQ case, isn't it?

I think they're both pretty niche, but still valid scenarios.

> > >   Sure. I have a patch which transitions printing to another CPU once in a
> > > while so single CPU isn't hogged for too long and that solves the issues I
> > > have observed. But Alan didn't like this solution so the issue is unfixed
> > > for now.
> > 
> > Interesting. Do you have a pointer to the thread?
>   The patchset posting starts here:
> https://lkml.org/lkml/2014/3/25/343
> 
>   Patch 5/8 is probably the most interesting for you (patches 1-4 are
> already in the mm tree).

Yikes, that's certainly more invasive than anything I had in mind!

Will
