Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3FQScS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:32:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3FQScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:32:17 -0400
Date: Mon, 17 Jun 2013 20:32:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Disable tracing on warning
Message-ID: <20130617183206.GB3204@twins.programming.kicks-ass.net>
References: <1371487375.18733.18.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371487375.18733.18.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:42:55PM -0400, Steven Rostedt wrote:
> Add a traceoff_on_warning option in both the kernel command line as well
> as a sysctl option. When set, any WARN*() function that is hit will cause
> the tracing_on variable to be cleared, which disables writing to the
> ring buffer.
> 
> This is useful especially when tracing a bug with function tracing. When
> a warning is hit, the print caused by the warning can flood the trace with
> the functions that producing the output for the warning. This can make the
> resulting trace useless by either hiding where the bug happened, or worse,
> by overflowing the buffer and losing the trace of the bug totally.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Neat;

Acked-by: Peter Zijlstra <peterz@infradead.org>
