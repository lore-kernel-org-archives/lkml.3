Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3KLObv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:31:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab3KLObu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:31:50 -0500
Date: Tue, 12 Nov 2013 15:31:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Message-ID: <20131112143147.GB6049@dhcp22.suse.cz>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52820030.6000806@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-11-13 18:17:20, Li Zefan wrote:
> Cc more people
> 
> On 2013/11/12 6:06, Shawn Bohrer wrote:
> > Hello,
> > 
> > This morning I had a machine running 3.10.16 go unresponsive but
> > before we killed it we were able to get the information below.  I'm
> > not an expert here but it looks like most of the tasks below are
> > blocking waiting on the cgroup_mutex.  You can see that the
> > resource_alloca:16502 task is holding the cgroup_mutex and that task
> > appears to be waiting on a lru_add_drain_all() to complete.

Do you have sysrq+l output as well by any chance? That would tell
us what the current CPUs are doing. Dumping all kworker stacks
might be helpful as well. We know that lru_add_drain_all waits for
schedule_on_each_cpu to return so it is waiting for workers to finish.
I would be really curious why some of lru_add_drain_cpu cannot finish
properly. The only reason would be that some work item(s) do not get CPU
or somebody is holding lru_lock.

-- 
Michal Hocko
SUSE Labs
