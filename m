Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3JOHHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:07:44 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47630 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3JOHHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:07:43 -0400
Date: Tue, 15 Oct 2013 09:07:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, tj@kernel.org,
        akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
Message-ID: <20131015070739.GD24584@gmail.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
 <20131011.140814.422793173894221852.davem@davemloft.net>
 <20131012165120.GA15116@gmail.com>
 <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Sat, 12 Oct 2013, Ingo Molnar wrote:
> 
> > Another problem is that the patch emails are not properly threaded to the
> > 0/6 patch and thus appear out of order and mixed up:
> >
> > 66216 N C Oct 11 Christoph Lamet (  36) [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4
> > 66217 N C Oct 11 David Miller    (  13) О©╫О©╫>
> > 66218 N C Oct 11 Christoph Lamet (  43) О©╫О©╫>[PATCH 1/6] net: ip4_datagram_connect: Use correct form of statistics update
> > 66219 N C Oct 11 Eric Dumazet    (  17) О©╫ О©╫О©╫>
> > 66220 N C Oct 11 Christoph Lamet ( 121) О©╫О©╫>[PATCH 2/6] percpu: Add raw_cpu_ops
> > 66221 N C Oct 11 Christoph Lamet ( 189) О©╫О©╫>[PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
> > 66222 N C Oct 11 Christoph Lamet (  64) О©╫О©╫>[PATCH 5/6] net: __this_cpu_inc in route.c
> > 66223 N C Oct 11 Christoph Lamet ( 103) О©╫О©╫>[PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA node
> > 66224 N C Oct 11 Christoph Lamet (  43) О©╫О©╫>[PATCH 4/6] Use raw_cpu_write for initialization of per cpu refcount.
> >
> > Note how the order is 1,2,6,5,3,4 with no threading instead of 1,2,3,4,5,6
> > with proper threading.
> 
> Threading is done by quilt and it has been doing that for a pretty long time.

The point is that it's not done properly, and hasn't been done properly by 
your past few submissions.

That kind of mess increase the cost of reviewing and processing your 
patches and that is why there are rules and suggestions about how patches 
should be submitted to lkml.

> > That won't cause email servers to reject the mails, it just makes the 
> > patches a bit harder to review.
> 
> I do not have any control over how my ISP sorts these emails. [...]

If you are subscribed to linux-kernel you can double check the mails as 
they arrive.

You can also do test-sends to yourself or a test email address on gmail 
without Cc:-ing lkml, to make sure it's all sense.

> > Most kernel developers tend to use 'git send-email' to send patches to 
> > lkml, and that method is working pretty reliably.
> 
> People are not allowed to use quilt for patches submitted to you?

PeterZ is using Quilt to submit patches and his submissions are perfect.

My only requirement is that the submissions should not be broken and messy 
and your submissions repeatedly failed on that regard.

I have no idea what is broken about your email setup, you'll have to debug 
it yourself by doing a couple of test submissions without Cc:-ing others.

I test email sending scripts every time I change tooling - it's not rocket 
science and you should stop trying to blame me for your broken tool chain.

> I just checked and git send-mail does the threading in the same way as 
> quilt. There would be no change.

Yet the threading in your submissions is broken.

The thing is, I don't really care with what tools and methods you solve 
the problem - the vast majority of kernel developers who are submitting 
patch series are able to solve it.

The important thing is that it is _your_ responsibility to make sure the 
end result is sane.

Thanks,

	Ingo
