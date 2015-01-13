Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbbAMIPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:15:41 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63874 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbAMIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:15:40 -0500
Date: Tue, 13 Jan 2015 09:15:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: add BUILD_BUG_ON() for string tables
Message-ID: <20150113081537.GA25318@dhcp22.suse.cz>
References: <1421088863-14270-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421088863-14270-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-01-15 10:54:23, Greg Thelen wrote:
> Use BUILD_BUG_ON() to compile assert that memcg string tables are in
> sync with corresponding enums.  There aren't currently any issues with
> these tables.  This is just defensive.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ef91e856c7e4..8d1ca6c55480 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3699,6 +3699,10 @@ static int memcg_stat_show(struct seq_file *m, void *v)
>  	struct mem_cgroup *mi;
>  	unsigned int i;
>  
> +	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_stat_names) !=
> +		     MEM_CGROUP_STAT_NSTATS);
> +	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_events_names) !=
> +		     MEM_CGROUP_EVENTS_NSTATS);
>  	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
>  
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> -- 
> 2.2.0.rc0.207.ga3a616c
> 

-- 
Michal Hocko
SUSE Labs
