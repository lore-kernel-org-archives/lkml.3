Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3KRJBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:01:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34229 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3KRJB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:01:27 -0500
Date: Mon, 18 Nov 2013 10:01:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131118090117.GE3866@twins.programming.kicks-ass.net>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
 <1384267617-3446-5-git-send-email-dsahern@gmail.com>
 <20131112145707.GV5056@laptop.programming.kicks-ass.net>
 <20131112150751.GA19321@ghostprotocols.net>
 <20131112151944.GX5056@laptop.programming.kicks-ass.net>
 <52824AE3.4050207@gmail.com>
 <20131112211121.GC25913@gmail.com>
 <20131113113439.GI21461@twins.programming.kicks-ass.net>
 <52864ED1.1080607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52864ED1.1080607@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:41:53AM -0700, David Ahern wrote:
> On 11/13/13, 4:34 AM, Peter Zijlstra wrote:
> >>>one option here is not allow page faults and system wide system calls.
> >>>system wide tracing needs mmap; page faults for a task can use write().
> >>>I left that option in case something like this came up.
> >>
> >>So maybe splice() sounds like the right long term solution after all? :-/
> >
> >Right until you put a tracepoint (kprobe) somewhere in whatever function
> >is used to transfer a single page into/from a splice pipe.
> >
> >You can always screw yourself over using this stuff, no exceptions.
> >
> 
> What now? Can we add the mmap path as an option?

I'd say an option is always a possibility, but someone please try what
happens if you use stupid large events (dwarf stack copies) on
PERF_COUNT_SW_PAGE_FAULTS (.period=1) while recording with mmap().

The other option is to simply disallow PERF_SAMPLE_STACK_USER for that
event.

Personally I think 8k copies for every event are way stupid anyway,
that's a metric ton of data at a huge cost.
