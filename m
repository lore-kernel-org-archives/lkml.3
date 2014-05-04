Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaEDLVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 07:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbaEDLVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 07:21:12 -0400
Date: Sun, 4 May 2014 13:20:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rfc][patch] perf,tools: Remove test_attr_* muck from perf.h
Message-ID: <20140504112029.GA1197@krava.brq.redhat.com>
References: <20140501082729.GM11096@twins.programming.kicks-ass.net>
 <20140501183505.GA2317@krava.redhat.com>
 <20140502115201.GI30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502115201.GI30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 01:52:01PM +0200, Peter Zijlstra wrote:
> On Thu, May 01, 2014 at 08:35:05PM +0200, Jiri Olsa wrote:
> > On Thu, May 01, 2014 at 10:27:30AM +0200, Peter Zijlstra wrote:
> > > Hi,
> > > 
> > > I occasionally build the odd program against raw perf and use perf.h for
> > > this.
> > > 
> > > Now I find that no longer works because of:
> > > 
> > > 52502bf201a85 ("perf tests: Add framework for automated perf_event_attr tests")
> > > 
> > > So revert the hunk touching on perf.h.
> > 
> > But but but, then you'll brake attr tests
> > 
> > > 
> > > Also, it seems to be for snake shit only, and snakes stink, except on a
> > > plane :-)
> > 
> > wanna get to lwn quotes page, huh? ;)
> > 
> > any details about the breakage? maybe we could find some
> > way to make you happy and keep the snake shit in place
> 
> linux-2.6/tools/perf# gcc -o perf_bug perf_bug.c
> /tmp/cclObJsz.o: In function `sys_perf_event_open':
> perf_bug.c:(.text+0x48): undefined reference to `test_attr__enabled'
> perf_bug.c:(.text+0x72): undefined reference to `test_attr__open'
> collect2: error: ld returned 1 exit status
> 
> Initially perf.h was meant to have just the syscall wrapper and few
> system level defines (like the membars etc..)
> 
> But now its grown all kinds of gunk outside of that.
> 
> So ideally we'd split the thing into two files, one which is a
> stand-alone syscall wrapper + system utils things and one which includes
> the former and adds all the perf (tool, not kernel) gunk on.
> 
> I see all sorts of extern perf_{host,guest} things and util/target.h
> includes.. that all should definitely move elsewhere.

sounds good, I'll prepare something along those lines

jirka
