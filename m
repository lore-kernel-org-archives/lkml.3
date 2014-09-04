Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaIDUuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:50:37 -0400
Received: from www.sr71.net ([198.145.64.142]:48236 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbaIDUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:50:36 -0400
Message-ID: <5408D09A.5030000@sr71.net>
Date: Thu, 04 Sep 2014 13:50:34 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andrew Morton <akpm@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net> <20140902221814.GA18069@cmpxchg.org> <5406466D.1020000@sr71.net> <20140903001009.GA25970@cmpxchg.org> <5406612E.8040802@sr71.net> <20140904150846.GA10794@cmpxchg.org>
In-Reply-To: <20140904150846.GA10794@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 08:08 AM, Johannes Weiner wrote:
> Dave Hansen reports a massive scalability regression in an uncontained
> page fault benchmark with more than 30 concurrent threads, which he
> bisected down to 05b843012335 ("mm: memcontrol: use root_mem_cgroup
> res_counter") and pin-pointed on res_counter spinlock contention.
> 
> That change relied on the per-cpu charge caches to mostly swallow the
> res_counter costs, but it's apparent that the caches don't scale yet.
> 
> Revert memcg back to bypassing res_counters on the root level in order
> to restore performance for uncontained workloads.

A quick sniff test shows performance coming back to what it was around
3.16 with this patch.  I'll run a more thorough set of tests and verify
that it's working well.


