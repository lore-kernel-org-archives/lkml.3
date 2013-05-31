Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3EaLCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:02:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab3EaLCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:02:06 -0400
Date: Fri, 31 May 2013 13:02:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130531110202.GB32491@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31-05-13 03:22:59, David Rientjes wrote:
> On Fri, 31 May 2013, Michal Hocko wrote:
[...]
> > > If the oom notifier is in the oom cgroup, it may not be able to       
> > > successfully read the memcg "tasks" file to even determine the set of 
> > > eligible processes.
> > 
> > It would have to use preallocated buffer and have mlocked all the memory
> > that will be used during oom event.
> > 
> 
> Wrong, the kernel itself allocates memory when reading this information 
> and that would fail in an oom memcg.

But that memory is not charged to a memcg, is it? So unless you are
heading towards global OOM you should be safe.

-- 
Michal Hocko
SUSE Labs
