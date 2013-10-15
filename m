Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3JOIXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:23:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50283 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3JOIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:23:34 -0400
Date: Tue, 15 Oct 2013 10:23:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Miller <davem@davemloft.net>,
        tj@kernel.org, akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
Message-ID: <20131015082316.GA10651@twins.programming.kicks-ass.net>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
 <20131011.140814.422793173894221852.davem@davemloft.net>
 <20131012165120.GA15116@gmail.com>
 <20131014103258.GY3081@twins.programming.kicks-ass.net>
 <00000141b8591950-3f399b8b-fdc7-41a0-b84c-bb632e8adba7-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141b8591950-3f399b8b-fdc7-41a0-b84c-bb632e8adba7-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 07:02:29PM +0000, Christoph Lameter wrote:
> On Mon, 14 Oct 2013, Peter Zijlstra wrote:
> 
> > > Most kernel developers tend to use 'git send-email' to send patches to
> > > lkml, and that method is working pretty reliably.
> >
> > I always use quilt mail, it typically adds a reference to the 0/0 email
> > and ensures the time of each msg is one second ahead of the previous one
> > to ensure order is correct.
> 
> Yes that I also what I expected to happen and what always happened in the
> past.
> 
> > I've no idea how Christoph managed to wreck this, but normally quilt
> > mail DTRT (as opposed to git send-email which used to default to
> > endlessly deep threads -- got fixed in 1.6 or 1.7 or thereabouts).
> 
> Well this is going through Amazon cloud email which may be wrecking
> things. Had a number of issues already with messages being delayed etc. I
> can try to revert to my home setup and see if that fixes things.

So your 0/x has:

Message-ID: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
Date: Fri, 11 Oct 2013 17:54:38 +0000

1/x has:

Message-Id: <00000141a8a7eb8a-370733b2-d230-4567-96e1-74c028998bff-000000@email.amazonses.com>
References: <20131011175518.634285474@linux.com>
Date: Fri, 11 Oct 2013 17:54:39 +0000

2/x has:

Message-Id: <00000141a8a7ecfe-16f29a32-36eb-4588-a87e-6ba8e0b3a91c-000000@email.amazonses.com>
References: <20131011175518.634285474@linux.com>
Date: Fri, 11 Oct 2013 17:54:39 +0000

3/x has:

Message-Id: <00000141a8a7fa10-998dfc65-4d07-4d83-999e-31cb0056cfb3-000000@email.amazonses.com>
References: <20131011175518.634285474@linux.com>
Date: Fri, 11 Oct 2013 17:54:42 +0000


So yes, Amazon is fucking with your email, not only the msgids
(obviously) but also the date stamps are not what quilt generates.

If someone from Amazon is reading this; please comment.
