Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KOMx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:53:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3KOMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:53:23 -0500
Date: Fri, 15 Nov 2013 13:53:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Message-ID: <20131115125314.GH10456@twins.programming.kicks-ass.net>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
 <1384460715-23198-11-git-send-email-acme@infradead.org>
 <20131115060643.GA9237@gmail.com>
 <5285FECE.7020802@intel.com>
 <20131115111032.GA18647@gmail.com>
 <52860529.50200@intel.com>
 <20131115115629.GB19004@gmail.com>
 <20131115120329.GH2965@twins.programming.kicks-ass.net>
 <5286191C.1090601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5286191C.1090601@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 02:52:44PM +0200, Adrian Hunter wrote:
> On 15/11/13 14:03, Peter Zijlstra wrote:
> > On Fri, Nov 15, 2013 at 12:56:29PM +0100, Ingo Molnar wrote:
> >> So, here's the current status quo, there's 4 basic types of profiling 
> >> that 99% of the people are using, in order of popularity:
> >>
> >> 	perf record <cmd>
> >> 	perf record -a sleep N
> >> 	perf record -p <PID>
> >> 	perf record -t <TID>
> >>
> >> The first two (which I'd guess comprise about 95% of real-world usage) 
> >> have inheritance enabled.
> >>
> >> The last two (-p/-t) have inheritance disabled by default.
> > 
> > Yes, and I would expect it to be disabled for the TID option as you
> > explicitly select a single threads.
> 
> So you want -t to imply -i ?
> 
> That means if you want inheritance you have to do
> 
> 	-t <TID> --no-no-inherit
> 
> Or do you want another option --inherit

/me boggles, they're not the same? ;-)

Maybe we should extend the option parser to know that a double negative
is a nop :-)
