Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaG2Vxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:53:42 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:65134 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaG2Vxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:53:39 -0400
Date: Tue, 29 Jul 2014 23:53:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 02/10] nohz: Kick full dynticks timer targets with an
 empty IPI
Message-ID: <20140729215333.GA14520@localhost.localdomain>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-3-git-send-email-fweisbec@gmail.com>
 <20140729113307.GW3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729113307.GW3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 01:33:07PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 07:37:28PM +0200, Frederic Weisbecker wrote:
> >  	if (tick_nohz_full_cpu(cpu)) {
> >  		if (cpu != smp_processor_id() ||
> >  		    tick_nohz_tick_stopped())
> 
> Not really a comment on this patch per-se, but why is that line broken?
> If I concat them its only 74 chars long.

Ah, probably a bad anticipation from me then :)

> 
> > +			kick_cpu_async(cpu);
> >  		return true;
> >  	}
