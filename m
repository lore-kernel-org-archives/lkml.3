Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3JBCWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 22:22:40 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:56124 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab3JBCWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 22:22:37 -0400
Date: Tue, 1 Oct 2013 22:22:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for
 cpu hotplug
Message-ID: <20131002022227.GR856@cmpxchg.org>
References: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 04:31:23PM -0700, David Rientjes wrote:
> for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
> cpu_online_mask doesn't change during the iteration.

There is no problem report here.

Is there a crash?

If it's just accuracy of the read, why would we care about some
inaccuracies in counters that can change before you even get the
results to userspace?  And care to the point where we hold up CPU
hotplugging for this?

Also, the fact that you directly sent this to Linus suggests there is
some urgency for this fix.  What's going on?

Thanks,
Johannes
