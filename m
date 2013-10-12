Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3JLQv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 12:51:26 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42106 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3JLQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 12:51:24 -0400
Date: Sat, 12 Oct 2013 18:51:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: cl@linux.com, tj@kernel.org, akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
Message-ID: <20131012165120.GA15116@gmail.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
 <20131011.140814.422793173894221852.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131011.140814.422793173894221852.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Most sites are rejecting your posting because the CC: list looked like 
> this:
> 
> Cc:	akpm@linuxfoundation.org
> Cc:	Steven Rostedt <srostedt@redhat.com>
> Cc:	linux-kernel@vger.kernel.org
> Cc:	Ingo Molnar <mingo@kernel.org>
> Cc:	Peter Zijlstra <peterz@infradead.org>
> Cc:	Thomas Gleixner <tglx@linutronix.de>
> 
> Please only specify one CC: list with a comma separated list of 
> recipients.

Another problem is that the patch emails are not properly threaded to the 
0/6 patch and thus appear out of order and mixed up:

66216 N C Oct 11 Christoph Lamet (  36) [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4
66217 N C Oct 11 David Miller    (  13) └─>
66218 N C Oct 11 Christoph Lamet (  43) ┬─>[PATCH 1/6] net: ip4_datagram_connect: Use correct form of statistics update
66219 N C Oct 11 Eric Dumazet    (  17) │ └─>
66220 N C Oct 11 Christoph Lamet ( 121) ├─>[PATCH 2/6] percpu: Add raw_cpu_ops
66221 N C Oct 11 Christoph Lamet ( 189) ├─>[PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
66222 N C Oct 11 Christoph Lamet (  64) ├─>[PATCH 5/6] net: __this_cpu_inc in route.c
66223 N C Oct 11 Christoph Lamet ( 103) ├─>[PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA node
66224 N C Oct 11 Christoph Lamet (  43) └─>[PATCH 4/6] Use raw_cpu_write for initialization of per cpu refcount.

Note how the order is 1,2,6,5,3,4 with no threading instead of 1,2,3,4,5,6 
with proper threading.

That won't cause email servers to reject the mails, it just makes the 
patches a bit harder to review.

Most kernel developers tend to use 'git send-email' to send patches to 
lkml, and that method is working pretty reliably.

The relevant 'git send-email' line is pretty well described in Greg's "The 
newbie's guide to hacking the Linux kernel" book:

  http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel

Thanks,

	Ingo
