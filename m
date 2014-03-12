Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaCLNLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:11:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaCLNLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:11:54 -0400
Date: Wed, 12 Mar 2014 14:11:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] mm: memcg: push !mm handling out to page cache
 charge function
Message-ID: <20140312131152.GC11831@dhcp22.suse.cz>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394587714-6966-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-03-14 21:28:30, Johannes Weiner wrote:
[...]
> @@ -4070,6 +4061,12 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  		return 0;
>  
>  	if (!PageSwapCache(page)) {
> +		/*
> +		 * Page cache insertions can happen without an actual
> +		 * task context, e.g. during disk probing on boot.

We read a page cache during disk probing? I have tried to find such a
code path but failed. Could you point me to such a path, please?
I thought that such probing is done from udev context but I am not
familiar with this area TBH.

Thanks!

> +		 */
> +		if (!mm)
> +			memcg = root_mem_cgroup;
>  		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
>  		if (ret != -ENOMEM)
>  			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
> -- 
> 1.9.0
> 

-- 
Michal Hocko
SUSE Labs
