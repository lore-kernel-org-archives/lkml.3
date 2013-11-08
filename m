Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3KHUsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:48:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43880 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3KHUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:48:44 -0500
Date: Fri, 8 Nov 2013 21:48:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131108204839.GD14606@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 03:23:07PM -0500, Vince Weaver wrote:
> On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> > 
> > There seem to be a loop that takes too long in intel_pmu_handle_irq(). Your two
> > previous reports seemed to suggest that lbr is involved, but not this one.
> 
> I may be wrong but I think everything between <NMI> and <EOE> is just
> noise from the NMI perf-event watchdog timer kicking in.

Ah good point.

So the pattern seem to be that irq work/perf_event_wakeup is involved, may be
interrupting a tracepoint event or so.

It would be nice if you enable CONFIG_FRAME_POINTER in your future reports
so that we get more precise traces. Or may be you actually enabled it and it
doesn't work?
 
> Why that code would be reading the LBR registers I don't know.

Yeah that's just an inconditional call to check if there is lbr branch to record.

> Vince
> 
> 
