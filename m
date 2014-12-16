Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaLPPdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:33:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:33:52 -0500
Date: Tue, 16 Dec 2014 16:33:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141216153333.GA3337@twins.programming.kicks-ass.net>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <548FBA62.5090603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548FBA62.5090603@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:51:46PM -0500, Sasha Levin wrote:
> I'm not sure if you've caught up on the RCU stall issue we've been trying
> to track down (https://lkml.org/lkml/2014/11/14/656), but could this "funny"
> balancing behaviour be "funny" enough to cause a stall?

Typically not, the worst degenerate modes are either running everything
on one cpu or constantly migrating tasks. Both suck performance wise,
but are 'valid' modes of operation.

RCU stalls require not actually getting to userspace or otherwise
delaying grace periods for egregious amounts of time. The only way I can
see that happening is a load-balance pass not finishing at all, and then
you'd consistently get stack traces from inside the balancer -- and I'm
not seeing that in the email referenced.
