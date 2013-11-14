Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3KNROY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:14:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60525 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3KNROQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:14:16 -0500
Date: Thu, 14 Nov 2013 18:14:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131114171405.GA2965@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1311141217470.8746@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311141217470.8746@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:20:35PM -0500, Vince Weaver wrote:
> 
> possibly not an issue with your patch, but found in nearby code:
> 
> in perf_trace_init:
> 
>         int event_id = p_event->attr.config;
> 
> 	...
> 
>                 if (tp_event->event.type == event_id &&
> 
> 
> note that "attr.config" is 64-bit but "event_id" is only 32-bit,
> so things like 0xffffffff00000018 will map to irq_work_exit.

I will have a look.

> I'm not sure if your PERM code properly handles this case, I don't have 
> time to work through the macro-magic in your patch.

Can't blame you; took me a fair chunk of the day to come up with this.
That trace event stuff is horrid.
