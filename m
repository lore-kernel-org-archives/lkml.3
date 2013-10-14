Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3JNKdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:33:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3JNKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:33:16 -0400
Date: Mon, 14 Oct 2013 12:32:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Miller <davem@davemloft.net>, cl@linux.com, tj@kernel.org,
        akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
Message-ID: <20131014103258.GY3081@twins.programming.kicks-ass.net>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
 <20131011.140814.422793173894221852.davem@davemloft.net>
 <20131012165120.GA15116@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131012165120.GA15116@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 06:51:20PM +0200, Ingo Molnar wrote:
> Another problem is that the patch emails are not properly threaded to the 
> 0/6 patch and thus appear out of order and mixed up:
> 
> 66216 N C Oct 11 Christoph Lamet (  36) [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4
> 66217 N C Oct 11 David Miller    (  13) └─>
> 66218 N C Oct 11 Christoph Lamet (  43) ┬─>[PATCH 1/6] net: ip4_datagram_connect: Use correct form of statistics update
> 66219 N C Oct 11 Eric Dumazet    (  17) │ └─>
> 66220 N C Oct 11 Christoph Lamet ( 121) ├─>[PATCH 2/6] percpu: Add raw_cpu_ops
> 66221 N C Oct 11 Christoph Lamet ( 189) ├─>[PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
> 66222 N C Oct 11 Christoph Lamet (  64) ├─>[PATCH 5/6] net: __this_cpu_inc in route.c
> 66223 N C Oct 11 Christoph Lamet ( 103) ├─>[PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA node
> 66224 N C Oct 11 Christoph Lamet (  43) └─>[PATCH 4/6] Use raw_cpu_write for initialization of per cpu refcount.
> 
> Note how the order is 1,2,6,5,3,4 with no threading instead of 1,2,3,4,5,6 
> with proper threading.
> 
> That won't cause email servers to reject the mails, it just makes the 
> patches a bit harder to review.
> 
> Most kernel developers tend to use 'git send-email' to send patches to 
> lkml, and that method is working pretty reliably.

I always use quilt mail, it typically adds a reference to the 0/0 email
and ensures the time of each msg is one second ahead of the previous one
to ensure order is correct.

I've no idea how Christoph managed to wreck this, but normally quilt
mail DTRT (as opposed to git send-email which used to default to
endlessly deep threads -- got fixed in 1.6 or 1.7 or thereabouts).
