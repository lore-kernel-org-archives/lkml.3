Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaFJLw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:52:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaFJLw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:52:57 -0400
Date: Tue, 10 Jun 2014 13:52:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Marian Marinov <mm@1h.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Message-ID: <20140610115254.GA25631@dhcp22.suse.cz>
References: <5396ED66.7090401@1h.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5396ED66.7090401@1h.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[More people to CC]
On Tue 10-06-14 14:35:02, Marian Marinov wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello,

Hi,

> a while back in 2012 there was a request for this functionality.
>   oom, memcg: handle sysctl oom_kill_allocating_task while memcg oom
>   happening
>
> This is the thread: https://lkml.org/lkml/2012/10/16/168
>
> Now we run a several machines with around 10k processes on each
> machine, using containers.
>
> Regularly we see OOM from within a container that causes performance
> degradation.

What kind of performance degradation and which parts of the system are
affected?

memcg oom killer happens outside of any locks currently so the only
bottleneck I can see is the per-cgroup container which iterates all
tasks in the group. Is this what is going on here?

> We are running 3.12.20 with the following OOM configuration and memcg
> oom enabled:
> 
> vm.oom_dump_tasks = 0
> vm.oom_kill_allocating_task = 1
> vm.panic_on_oom = 0
> 
> When OOM occurs we see very high numbers for the loadavg and the
> overall responsiveness of the machine degrades.

What is the system waiting for?

> During these OOM states the load of the machine gradualy increases
> from 25 up to 120 in the interval of 10minutes.
>
> Once we manually bring down the memory usage of a container(killing
> some tasks) the load drops down to 25 within 5 to 7 minutes.

So the OOM killer is not able to find a victim to kill?

> I read the whole thread from 2012 but I do not see the expected
> behavior that is described by the people that commented the issue.

Why do you think that killing the allocating task would be helpful in
your case?

> In this case, with real usage for this patch, would it be considered
> for inclusion?

I would still prefer to fix the real issue which is not clear from your
description yet.

-- 
Michal Hocko
SUSE Labs
