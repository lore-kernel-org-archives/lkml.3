Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3K1JNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:13:17 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54510 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3K1JNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:13:05 -0500
Date: Thu, 28 Nov 2013 10:12:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        azurit@pobox.sk, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from
 -mm tree
Message-ID: <20131128091255.GD2761@dhcp22.suse.cz>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org>
 <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com>
 <20131127233353.GH3556@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127233353.GH3556@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-11-13 18:33:53, Johannes Weiner wrote:
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 13b9d0f..5f9e467 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2675,7 +2675,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  		goto bypass;
>  
>  	if (unlikely(task_in_memcg_oom(current)))
> -		goto bypass;
> +		goto nomem;
>  
>  	/*
>  	 * We always charge the cgroup the mm_struct belongs to.

Yes, I think we really want this. Plan to send a patch? The first charge
failure due to OOM shouldn't be papered over by a later attempt if we
didn't get through mem_cgroup_oom_synchronize yet.

-- 
Michal Hocko
SUSE Labs
