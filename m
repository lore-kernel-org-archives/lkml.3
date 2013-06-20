Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935699Ab3FTDfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:35:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59417 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935546Ab3FTDfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:35:01 -0400
Message-ID: <51C27855.8010905@huawei.com>
Date: Thu, 20 Jun 2013 11:34:45 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Robin Holt <holt@sgi.com>, Alex Thorlton <athorlton@sgi.com>,
        <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        <linux-doc@vger.kernel.org>, <linux-mm@kvack.org>,
        Tejun Heo <tj@kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] Make transparent hugepages cpuset aware
References: <1370967244-5610-1-git-send-email-athorlton@sgi.com> <alpine.DEB.2.02.1306111517200.6141@chino.kir.corp.google.com> <20130618164537.GJ16067@sgi.com> <alpine.DEB.2.02.1306181654350.4503@chino.kir.corp.google.com> <20130619093212.GX3658@sgi.com> <alpine.DEB.2.02.1306191419081.13015@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1306191419081.13015@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tejun, and cgroup ML

>> Here are the entries in the cpuset:
>> cgroup.event_control  mem_exclusive    memory_pressure_enabled  notify_on_release         tasks
>> cgroup.procs          mem_hardwall     memory_spread_page       release_agent
>> cpu_exclusive         memory_migrate   memory_spread_slab       sched_load_balance
>> cpus                  memory_pressure  mems                     sched_relax_domain_level
>>
>> There are scheduler, slab allocator, page_cache layout, etc controls.
> 
> I think this is mostly for historical reasons since cpusets were 
> introduced before cgroups.
> 
>> Why _NOT_ add a thp control to that nicely contained central location?
>> It is a concise set of controls for the job.
>>
> 
> All of the above seem to be for cpusets primary purpose, i.e. NUMA 
> optimizations.  It has nothing to do with transparent hugepages.  (I'm not 
> saying thp has anything to do with memcg either, but a "memory controller" 
> seems more appropriate for controlling thp behavior.)
> 
>> Maybe I am misunderstanding.  Are you saying you want to put memcg
>> information into the cpuset or something like that?
>>
> 
> I'm saying there's absolutely no reason to have thp controlled by a 
> cpuset, or ANY cgroup for that matter, since you chose not to respond to 
> the question I asked: why do you want to control thp behavior for certain 
> static binaries and not others?  Where is the performance regression or 
> the downside?  Is it because of max_ptes_none for certain jobs blowing up 
> the rss?  We need information, and even if were justifiable then it 
> wouldn't have anything to do with ANY cgroup but rather a per-process 
> control.  It has nothing to do with cpusets whatsoever.
> 
> (And I'm very curious why you didn't even cc the cpusets maintainer on 
> this patch in the first place who would probably say the same thing.)
> .

Don't know whom you were refering to here. It's Paul Jackson who invented
cpusets, and then Paul Menage took over the maintainership but he wasn't
doing much maintainer's work. Now it's me and Tejun maintaining cpusets.
(long ago Ingo once requested cpuset patches should be cced to him and
Peter.)

Back to this patch, I'm definitely on your side. This feature doesn't
interact with existing cpuset features, and it doens't need anything
that cpuset provides. In a word, it has nothing to do with cpusets hence
it shouldn't belong to cpusets.

We're clearing all the messes in cgroups, and this patch acts in the
converse direction.

