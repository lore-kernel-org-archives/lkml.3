Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab3JPPgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:36:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3JPPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:36:22 -0400
Date: Wed, 16 Oct 2013 17:36:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131016153603.GZ10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.813545438@linux.com>
 <20131016084920.GT10651@twins.programming.kicks-ass.net>
 <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:09:13PM +0000, Christoph Lameter wrote:
> On Wed, 16 Oct 2013, Peter Zijlstra wrote:
> 
> > So I didn't understand what was wrong with:
> >
> > #define __this_cpu_read(pcp) \
> > 	(__this_cpu_preempt_check("read"), raw_this_cpu_read(pcp))
> >
> > And idem for all others. This is 1) shorter to write; and 2) makes it
> > blindingly obvious that the implementations are actually the same.
> 
> Nothing wrong with that. It just increases the scope of this patch to
> require modifications to arch code and I already have trouble enough
> following through on all the issues that were raised so far.
> 

But non of your raw ops touch arch code... /me confused.
