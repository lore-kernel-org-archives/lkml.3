Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaJXP6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:58:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaJXP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:58:08 -0400
Date: Fri, 24 Oct 2014 17:58:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Burke Libbey <burke.libbey@shopify.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141024155805.GF21513@worktop.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024150746.GB25260@burke.local>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:07:46AM -0400, Burke Libbey wrote:
> From 2014-02-15: https://lkml.org/lkml/2014/2/15/217
> 
> This issue was reported and patched, but it still occurs in some situations on
> newer kernel versions.
> 
> [2249353.328452] BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
> [2249353.336528] IP: [<ffffffff810b1cf7>] check_preempt_wakeup+0xe7/0x210
> 
> se.parent gets out of sync with se.depth, causing a panic when the algorithm in
> find_matching_se assumes they are correct. This patch forces se.depth to be
> updated every time se.parent is, so they can no longer become desync'd.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Burke Libbey <burke.libbey@shopify.com>
> ---
> 
> I haven't been able to isolate the problem. Though I'm pretty confident this
> fixes the issue I've been having, I have not been able to prove it.

So this isn't correct, switching rq should not change depth. I suspect
you're just papering over the issue by frequently resetting the value,
which simply narrows the race window.

