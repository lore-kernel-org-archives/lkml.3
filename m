Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaG2MHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:07:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaG2MHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:07:48 -0400
Date: Tue, 29 Jul 2014 14:07:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 05/10] smp: Fast path check on IPI list
Message-ID: <20140729120739.GX3935@laptop>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406569056-30217-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:37:31PM +0200, Frederic Weisbecker wrote:
> When we enqueue a remote irq work, we trigger the same IPI as those
> raised by smp_call_function_*() family.
> 
> So when we receive such IPI, we check both irq_work and smp_call_function
> queues. Thus if we trigger a remote irq work, we'll likely find the
> smp_call_function queue empty unless we collide with concurrent enqueuers
> but the probability is low.
> 
> Meanwhile, checking the smp_call_function queue can be costly because
> we use llist_del_all() which relies on cmpxchg().

xchg()
