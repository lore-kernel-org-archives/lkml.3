Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaILHlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:41:22 -0400
Received: from mx2.parallels.com ([199.115.105.18]:43695 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaILHlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:41:20 -0400
Date: Fri, 12 Sep 2014 11:41:04 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] memcg: use percpu_counter for statistics
Message-ID: <20140912074104.GG4151@esperanza>
References: <cover.1410447097.git.vdavydov@parallels.com>
 <395271ceb801fdb6b97160bbdd38fa2214b29983.1410447097.git.vdavydov@parallels.com>
 <5412481C.2020101@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5412481C.2020101@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:10:52AM +0900, Kamezawa Hiroyuki wrote:
> (2014/09/12 0:41), Vladimir Davydov wrote:
> > In the next patch I need a quick way to get a value of
> > MEM_CGROUP_STAT_RSS. The current procedure (mem_cgroup_read_stat) is
> > slow (iterates over all cpus) and may sleep (uses get/put_online_cpus),
> > so it's a no-go.
> > 
> > This patch converts memory cgroup statistics to use percpu_counter so
> > that percpu_counter_read will do the trick.
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> 
> 
> I have no strong objections but you need performance comparison to go with this.
> 
> I thought percpu counter was messy to be used for "array".
> I can't understand why you started from fixing future performance problem before
> merging new feature.

Because the present implementation of mem_cgroup_read_stat may sleep
(get/put_online_cpus) while I need to call it from atomic context in the
next patch.

I didn't do any performance comparisons, because it's just an RFC. It
exists only to attract attention to the problem. Using percpu counters
was the quickest way to implement a draft version, that's why I chose
them. It may have performance impact though, so it shouldn't be merged
w/o performance analysis.

Thanks,
Vladimir
