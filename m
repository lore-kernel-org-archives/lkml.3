Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab3HMWe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:34:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41040 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759274Ab3HMWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:34:56 -0400
Date: Tue, 13 Aug 2013 18:34:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20130813223453.GB15394@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com> <877hc64klm.fsf@rustcorp.com.au> <20130813111442.632f3421@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813111442.632f3421@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> But the thing about this that bothers me is that there's no way to say,
> "Enable all tracepoints in this module on load". I would like a way to
> do that, but I don't know of a way to do that without modifying the
> module code. Have any ideas? Basically, I would love to have:
> 
> insmod foo tracepoints=all
> 
> or something and have all tracepoints enabled.

If it can help, here is a very similar scenario: tracepoints in
lttng-ust (user land) deal with dynamically loaded libraries that are
loaded at any point during program execution, which is very much similar
to the kernel module use-case discussed here.

The way a user interacts with lttng to enable, e.g. all tracepoints
within "app_component" would be:

lttng enable-event -u 'app_component:*'

Then, whenever a library containing tracepoints is loaded, the
tracepoints contained within the library are registered to lttng-ust,
and it enables all tracepoint matching the user-specified wildcard.

What I like about this approach, if applied to kernel modules, is that
it does not require users to interact with module load parameters to
specify which tracepoints should be enabled: this is all done through
the regular tracer UI, thus greatly improving user experience.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
