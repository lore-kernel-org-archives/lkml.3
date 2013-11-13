Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3KMLfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:35:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55360 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3KMLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:35:02 -0500
Date: Wed, 13 Nov 2013 12:34:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131113113439.GI21461@twins.programming.kicks-ass.net>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
 <1384267617-3446-5-git-send-email-dsahern@gmail.com>
 <20131112145707.GV5056@laptop.programming.kicks-ass.net>
 <20131112150751.GA19321@ghostprotocols.net>
 <20131112151944.GX5056@laptop.programming.kicks-ass.net>
 <52824AE3.4050207@gmail.com>
 <20131112211121.GC25913@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112211121.GC25913@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:11:21PM +0100, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > > Dunno.. it _should_ all work. Try it and see what it does.. Once the 
> > > events are bigger than a page things might get 'interesting' though.
> 
> Which could be the case with call-graph recording, right?

Not typically, I think we're limiting call graphs to 127 u64, which is
~1k. Maybe you can blow the single page if you also do a large
top-of-stack copy for dwarf/unwind nonsense.

> > one option here is not allow page faults and system wide system calls. 
> > system wide tracing needs mmap; page faults for a task can use write(). 
> > I left that option in case something like this came up.
> 
> So maybe splice() sounds like the right long term solution after all? :-/

Right until you put a tracepoint (kprobe) somewhere in whatever function
is used to transfer a single page into/from a splice pipe.

You can always screw yourself over using this stuff, no exceptions.
