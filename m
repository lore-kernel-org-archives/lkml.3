Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3BAKOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab3BAKOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:14:06 -0500
Date: Fri, 1 Feb 2013 11:13:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: Andreas Hollmann <hollmann@in.tum.de>, linux-perf-users@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Mixed group of sw/hw counters are not started if sw counter is
 group leader
Message-ID: <20130201101347.GB1078@krava.brq.redhat.com>
References: <CAGz0_-0ti+_3cXQhYUAb_-zKqHBcPVYjFtQ86ZGr8utXF13Rag@mail.gmail.com>
 <20130129123908.GC8339@krava.brq.redhat.com>
 <CAGz0_-2O+7a5Bkeu3vgNFYrsGGYJxrqECKQUJJTwSDQZBktLjw@mail.gmail.com>
 <20130129140110.GF8339@krava.brq.redhat.com>
 <20130129153720.GG8339@krava.brq.redhat.com>
 <alpine.DEB.2.02.1301291153490.538@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301291153490.538@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 11:56:01AM -0500, Vince Weaver wrote:
> On Tue, 29 Jan 2013, Jiri Olsa wrote:
> 
> > ok, there's been perf fixies wrt enable events groups, but they
> > landed in 3.8-rc1.. until that point all the group members are
> > specifically enabled, so that's why your perf is working and
> > mine not..
> > 
> > Anyway, seems like there's bug in kernel code when we have group
> > with sw and hw counters.
> > 
> > Attached path makes your test case working for me. I'll give it some
> > more thoughts & testing and send it out soon. If you like to test,
> > please go ahead.
> 
> I've added a test to my perf_event_test testsuite to look for this bug.
>    http://www.eece.maine.edu/~vweaver/projects/perf_events/validation/
> 
> In my (minimal) testing so far it looks like this bug does exist in 3.2
> but does not in 2.6.35.  Is anyone curious enough to do a bisect to find 
> out when it was introduced?

I found this started at v2.6.37 where following commit that introduced
the group moving was added:

perf: Complete software pmu grouping
commit b04243ef7006cda301819f54ee7ce0a3632489e3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Sep 17 11:28:48 2010 +0200

I could not get finer bisection within 2.6.37 because the kernel
deadlocked each time I ran the test.

But it seems this problem is there from the introducing
of the group moving.

CCing more folks and lkml

jirka
