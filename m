Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbbAWP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:58:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34090 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754866AbbAWP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:58:01 -0500
Date: Fri, 23 Jan 2015 07:57:24 -0800
From: Shaohua Li <shli@fb.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <Kernel-team@fb.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 2/2] perf: update userspace page info for software event
Message-ID: <20150123155724.GA631220@devbig257.prn2.facebook.com>
References: <119aa7d433860f568136ab623fb4a510c28e9e6f.1421906750.git.shli@fb.com>
 <e0f8f6f0a114c464e8e38cd73be31564bd5ea7da.1421906750.git.shli@fb.com>
 <20150123084451.GE2896@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150123084451.GE2896@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_05:2015-01-23,2015-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=29.7537444223261
 compositescore=0.928745990228454 urlsuspect_oldscore=0.928745990228454
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928745990228454 spamscore=0
 recipient_to_sender_domain_totalscore=11 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501230150
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:44:51AM +0100, Peter Zijlstra wrote:
> On Thu, Jan 22, 2015 at 01:09:02PM -0800, Shaohua Li wrote:
> > ---
> >  kernel/events/core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 4edde3e..4221240 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -5950,6 +5950,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
> >  	}
> >  
> >  	hlist_add_head_rcu(&event->hlist_entry, head);
> > +	perf_event_update_userpage(event);
> >  
> >  	return 0;
> >  }
> > @@ -6419,6 +6420,7 @@ static int cpu_clock_event_add(struct perf_event *event, int flags)
> >  {
> >  	if (flags & PERF_EF_START)
> >  		cpu_clock_event_start(event, flags);
> > +	perf_event_update_userpage(event);
> >  
> >  	return 0;
> >  }
> > @@ -6493,6 +6495,7 @@ static int task_clock_event_add(struct perf_event *event, int flags)
> >  {
> >  	if (flags & PERF_EF_START)
> >  		task_clock_event_start(event, flags);
> > +	perf_event_update_userpage(event);
> >  
> >  	return 0;
> >  }
> 
> How about the one I sent; which adds it to {start,stop} instead of add?
> {start,stop} is the right place to add them, although this add might be
> sufficient for your use case.
Hi Peter,
I tried {start, stop}, it doesn't work (doesn't get called in context
switch) and I still get a CLOCK_MONOTONIC. So I added it to .add, which
is called in context switch and I got correct thread time. Am I missing
anything?

Thanks,
Shaohua
