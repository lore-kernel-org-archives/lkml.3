Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JHTjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:39:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38006 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:39:30 -0400
Date: Tue, 8 Oct 2013 21:39:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008193927.GB7315@gmail.com>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
 <20131008153518.GB15214@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008153518.GB15214@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, Oct 08, 2013 at 08:59:38AM +0200, Ingo Molnar wrote:
> > 
> > Secondly and more importantly, visualized with relative sizes, in a 
> > feature matrix, makes it clearer what's going on with vmlinux .text:
> > 
> >                               perf-OFF   perf-ON
> > 
> >             ftrace-OFF               0     +151k
> > 
> >             ftrace-ON            +897k    +1142k
> > 
> > So basically ftrace is causing a big chunk of the instrumentation size 
> > increase. With tons of tracers and lots of kernel subsystems built into 
> > your .config that's a lot of nice instrumentation functionality and it's 
> > thus also a natural end result IMO.
> 
> I'm curious what you turned on for between the "ftrace-OFF" and "ftrace-ON"?

ON: all the tracing bits in Andi's original config - which had most 
tracing options enabled AFAICS.

OFF: all of it turned off.

I don't think there's anything inherently wrong with 3000+ tracepoints 
built into the kernel using up a fair amount of cold-path space. We should 
try to compress it all, but it's a hell of a lot real functionality.

> The one thing that you didn't post was CONFIG_EVENT_TRACING. This is 
> where a lot of bloat can come from, as this enables the infrastructure 
> for tracepoints. This is also needed by perf to trace most sw events.

Correct.

EVENT_TRACING was on - Andi did not post his .config publicly, but you can 
get something fairly close to his config by doing this:

	make defconfig
	cat config-options.txt >> .config
	make oldconfig

where 'config-options.txt' is the short list of options I appended to my 
mail.

> The trace event infrastructure that both perf and ftrace uses (as well 
> as other tracers and tools) is well known to cause bloat in the kernel. 
> There's patches to help make it more bearable, but there's more work to 
> be done.

It's 3000+ very nice tracepoints - which is a huge multiplier, so we 
should not expect any miracles - it's a whole lot of good functionality. 
Subsystems can decide whether they want to expose their tracepoints or 
not.

Thanks,

	Ingo
