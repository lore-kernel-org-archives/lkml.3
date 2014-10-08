Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaJHKcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:32:55 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36642 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaJHKcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:32:54 -0400
Date: Wed, 8 Oct 2014 11:32:50 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/11] perf: Move cgroup init before PMU ->event_init()
Message-ID: <20141008103250.GO14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-7-git-send-email-matt@console-pimps.org>
 <20141007193424.GB4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007193424.GB4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct, at 09:34:24PM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:10PM +0100, Matt Fleming wrote:
> > +++ b/kernel/events/core.c
> > @@ -6859,7 +6859,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
> >  		 struct perf_event *group_leader,
> >  		 struct perf_event *parent_event,
> >  		 perf_overflow_handler_t overflow_handler,
> > -		 void *context)
> > +		 void *context, bool cgroup, pid_t pid)
> >  {
> >  	struct pmu *pmu;
> >  	struct perf_event *event;
> 
> I don't get this extension, why a bool and pid_t ?

So that it's possible to figure out whether we need to call
perf_cgroup_connect(). 

Oh, why not just 'int fd', you mean? Ermm... yeah that would be better.

-- 
Matt Fleming, Intel Open Source Technology Center
