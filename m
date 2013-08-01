Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3HAOTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:19:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40107 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3HAOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:19:23 -0400
Date: Thu, 1 Aug 2013 16:19:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130801141916.GG431@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
 <20130801124658.GC1032@krava.brq.redhat.com>
 <20130801133155.GB27162@twins.programming.kicks-ass.net>
 <20130801135525.GE431@somewhere>
 <20130801140352.GE27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801140352.GE27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 04:03:52PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 01, 2013 at 03:55:27PM +0200, Frederic Weisbecker wrote:
> > On Thu, Aug 01, 2013 at 03:31:55PM +0200, Peter Zijlstra wrote:
> > > 
> > > Where the freq thing is new and shiney, but we already had the other
> > > two. Of those, cgroup events must be per cpu so that should be good,
> > > the branch_stack thing tests ATTACH_TASK, which should also be good, but
> > > leaves me wonder wth they do for those that are attached to tasks.
> > > 
> > > But yes, the frequency thing is borken.
> > 
> > Aie, so the freq thing,  I can either account to all CPUs (inc to all
> > and send an IPI to all), or when the event scheds in/out. Probably we
> > should do the former to avoid sending an IPI at all context switches.
> 
> Yeah, just go with a single global state for now..

A single global counter? Ok sounds good.
