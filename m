Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3K1Rke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:40:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54579 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab3K1Rk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:40:29 -0500
Date: Thu, 28 Nov 2013 18:40:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, David Miller <davem@davemloft.net>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 7/8] sched, net: Fixup busy_loop_us_clock()
Message-ID: <20131128174001.GH10022@twins.programming.kicks-ass.net>
References: <20131126155743.116756708@infradead.org>
 <20131126160815.293633156@infradead.org>
 <529773FC.6020707@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529773FC.6020707@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 06:49:00PM +0200, Eliezer Tamir wrote:
> I have tested this patch and I see a performance regression of about
> 1.5%.

Cute, can you qualify your metric? Since this is a poll loop the only
metric that would be interesting is the response latency. Is that what's
increased by 1.5%? Also, what's the standard deviation of your result?

Also, can you provide relevant perf results for this? Is it really the
sti;cli pair that's degrading your latency?

Better yet, can you provide us with a simple test-case that we can run
locally (preferably single machine setup, using localnet or somesuch).

> Maybe it would be better, rather then testing in the fast path, to
> simply disallow busy polling altogether when sched_clock_stable is
> not true?

Sadly that doesn't work; sched_clock_stable can become false at any time
after boot (and does, even on recent machines).

That said; let me see if I can come up with a few patches to optimize
the entire thing; that'd be something we all benefit from.
