Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaDVKeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:34:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaDVKeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:34:23 -0400
Date: Tue, 22 Apr 2014 12:34:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in
 mem_cgroup_iter()
Message-ID: <20140422103420.GI29311@dhcp22.suse.cz>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz>
 <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 18:17:09, Jianyu Zhan wrote:
> On Tue, Apr 22, 2014 at 5:47 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > What about
> >   3. last_visited == last_node in the tree
> >
> > __mem_cgroup_iter_next returns NULL and the iterator would return
> > without visiting anything.
> 
> Hi,  Michal,
> 
> yep,  if 3 last_visited == last_node, then this means we have done a round-trip,
> thus __mem_cgroup_iter_next returns NULL, in turn mem_cgroup_iter() return NULL.

Sorry, I should have been more specific that I was talking about
mem_cgroup_reclaim_cookie path where the iteration for this particular
zone and priority ended at the last node without finishing the full
roundtrip last time. This new iteration (prev==NULL) wants to continue
and it should start a new roundtrip.

Makes sense?
-- 
Michal Hocko
SUSE Labs
