Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3KSNpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:45:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3KSNpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:45:23 -0500
Date: Tue, 19 Nov 2013 14:45:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119134508.GN3866@twins.programming.kicks-ass.net>
References: <877gc5utkf.fsf@sejong.aot.lge.com>
 <528AB229.6030603@gmail.com>
 <87wqk5t9yd.fsf@sejong.aot.lge.com>
 <528ACA41.4030202@gmail.com>
 <87ob5ht962.fsf@sejong.aot.lge.com>
 <528ACDE7.3050107@gmail.com>
 <20131119065835.GB32367@gmail.com>
 <20131119114810.GK3866@twins.programming.kicks-ass.net>
 <20131119114959.GE3694@twins.programming.kicks-ass.net>
 <20131119131304.GC7263@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119131304.GC7263@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:13:04PM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Nov 19, 2013 at 12:48:10PM +0100, Peter Zijlstra wrote:
> > > And that does indeed seem to side-step the perf sw pagefault event, but
> > > that is arguably a perf bug.
> > 
> > To clarify; mm/memory.c:handle_mm_fault() is where the VM counts its 
> > generic PGFAULT event, but our perf sw event is in the arch fault 
> > handler.
> > 
> > So they count different but related things.
> 
> I think that assymetry was intended: we didn't want to count 
> 'synchronous' pagefaults like get_user_pages() or mlock() bringing in 
> pages, only asynchronous/real ones, or so.

OK, I couldn't remember.

Anyway, I don't want to hold up this patch set, and the speedup in the
'normal' case is nice.

The only reason I reacted was because the changelog mentioned avoiding a
feedback loop -- so I obviously had to point out that it didn't do such
a thing, it only changed the details of the loop.

I'm fairly certain this particular problem is unavoidable, no matter
what the mechanism used, you can always create feedback.

At some point people will just have to know wtf they're doing. Also, I
don't think anything really bad happens, at worst we'll just drop a
bunch of events because the output cannot keep up for obvious reasons.
