Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaEGOz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:55:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaEGOz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:55:56 -0400
Date: Wed, 7 May 2014 16:55:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/9] mm: memcontrol: catch root bypass in move precharge
Message-ID: <20140507145553.GJ9489@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:38, Johannes Weiner wrote:
[...]
> @@ -6546,8 +6546,9 @@ one_by_one:
>  			cond_resched();
>  		}
>  		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
> +		if (ret == -EINTR)
> +			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
>  		if (ret)
> -			/* mem_cgroup_clear_mc() will do uncharge later */

I would prefer to keep the comment and explain that we will loose return
code on the way and that is why cancel on root has to be done here.

>  			return ret;
>  		mc.precharge++;
>  	}
> -- 
> 1.9.2
> 

-- 
Michal Hocko
SUSE Labs
