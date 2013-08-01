Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3HAOD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:03:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3HAOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:03:58 -0400
Date: Thu, 1 Aug 2013 16:03:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130801140352.GE27162@twins.programming.kicks-ass.net>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
 <20130801124658.GC1032@krava.brq.redhat.com>
 <20130801133155.GB27162@twins.programming.kicks-ass.net>
 <20130801135525.GE431@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801135525.GE431@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:55:27PM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 01, 2013 at 03:31:55PM +0200, Peter Zijlstra wrote:
> > 
> > Where the freq thing is new and shiney, but we already had the other
> > two. Of those, cgroup events must be per cpu so that should be good,
> > the branch_stack thing tests ATTACH_TASK, which should also be good, but
> > leaves me wonder wth they do for those that are attached to tasks.
> > 
> > But yes, the frequency thing is borken.
> 
> Aie, so the freq thing,  I can either account to all CPUs (inc to all
> and send an IPI to all), or when the event scheds in/out. Probably we
> should do the former to avoid sending an IPI at all context switches.

Yeah, just go with a single global state for now..
