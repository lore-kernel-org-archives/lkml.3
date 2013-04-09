Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849Ab3DID7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:59:13 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35568 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113Ab3DID7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:59:12 -0400
Date: Mon, 8 Apr 2013 20:59:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
Message-ID: <20130409035907.GA4565@mtj.dyndns.org>
References: <5162648B.9070802@huawei.com>
 <51626584.7050405@huawei.com>
 <5163868B.3020905@jp.fujitsu.com>
 <5163887D.1040809@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163887D.1040809@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:18:21AM +0800, Li Zefan wrote:
> >> -		if (memcg->memcg_name)
> >> -			seq_printf(m, "%s:\n", memcg->memcg_name);
> >> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
> >> +		if (!ret)
> >> +			seq_printf(m, "%s:\n", memcg_name);
> >>   		else
> >>   			seq_printf(m, "%p (name lost):\n", memcg);
> >>   
> > 
> > I'm sorry for dawm question ...when this error happens ?
> > We may get ENAMETOOLONG even with PAGE_SIZE(>=4096bytes) buffer ?
> > 
> 
> It does no harm to check the return value, and we don't have to
> worry about if cgroup_path() will be changed to return some other
> errno like ENOMEM in the future.

Maybe change the function to return the length of the path regardless
of the specified buffer length?  ie. as in snprintf()?

-- 
tejun
