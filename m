Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061Ab3JPQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:52:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:39118 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760798Ab3JPQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:52:42 -0400
Date: Wed, 16 Oct 2013 12:52:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131016125238.5f970fd5@gandalf.local.home>
In-Reply-To: <20131016162537.GB10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
	<20131015174747.813545438@linux.com>
	<20131016084920.GT10651@twins.programming.kicks-ass.net>
	<00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
	<20131016153603.GZ10651@twins.programming.kicks-ass.net>
	<00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com>
	<20131016162537.GB10651@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 18:25:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:
 
> But yes, the way its set-up an arch could indeed provide __this_cup_$op
> itself -- without providing the _$n variants; in which case the
> raw_cpu_$op provided by you is broken.
> 
> Can't we have a 'simple' coccinelle script rename the entire __this_cpu*
> implementation over to raw_cpu* and then provide generic __this_cpu* ->
> raw_cpu maps?
> 

Perhaps we should match the way spinlocks are.


this_cpu*() be the normal use.

raw_this_cpu() could perhaps not do the checks?

arch_this_cpu() be the architecture specific version of this_cpu*


-- Steve
