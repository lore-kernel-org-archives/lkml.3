Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaEVCfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:35:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaEVCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:35:15 -0400
Message-ID: <537D6244.6040106@oracle.com>
Date: Wed, 21 May 2014 22:34:44 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
References: <5371122D.6020605@oracle.com> <537AB86B.4020901@oracle.com> <20140520110431.GX2485@laptop.programming.kicks-ass.net> <537B52BD.1080807@oracle.com> <537CA54A.8030408@oracle.com> <20140521131948.GF2485@laptop.programming.kicks-ass.net> <20140521164959.GI5226@laptop.programming.kicks-ass.net>
In-Reply-To: <20140521164959.GI5226@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 12:49 PM, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 03:19:48PM +0200, Peter Zijlstra wrote:
>> > On Wed, May 21, 2014 at 09:08:26AM -0400, Sasha Levin wrote:
>>> > > +++ b/kernel/sched/core.c
>>> > > @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
>>> > >                 goto out;
>>> > > 
>>> > >         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
>>> > > +       BUG_ON(cur == p);
>>> > >         ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
>>> > > 
>>> > >  out:
>>> > > 
>>> > > 
>>> > > Which seems to get hit. This sounds like a race with task moving to
>>> > > other cpu maybe?
>> > 
>> > Oi, good call that, lemme go stare.
> I think something simple like this should be sufficient to avoid the
> problem of selecting oneself as a flip target.

Why would that happen in the first place?


Thanks,
Sasha
