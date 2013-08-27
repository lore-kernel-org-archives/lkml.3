Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3H0MQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:16:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3H0MQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:16:39 -0400
Date: Tue, 27 Aug 2013 14:16:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130827121629.GE10002@twins.programming.kicks-ass.net>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
 <20130826175012.GA25202@redhat.com>
 <20130826141814.54dcaa89@gandalf.local.home>
 <20130826182907.GB25202@redhat.com>
 <20130826150304.090a1025@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826150304.090a1025@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 03:03:04PM -0400, Steven Rostedt wrote:
> > Is there some path through sys_perf_open_event that might be
> > missing a capability check perhaps ?
> > 
> 
> That's a question for Ingo, Peter or Jiri.

Its not something I've looked at recently, git blames Jiri and fweisbec
for most of that code.

Permission checks appear to live in
kernel/trace/trace_event_perf.c:perf_trace_event_perm().
