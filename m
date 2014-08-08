Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaHHIVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:21:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbaHHIV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:21:28 -0400
Date: Fri, 8 Aug 2014 10:21:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb_cgroup: align hugetlb cgroup limit to
 hugepage size
Message-ID: <20140808082126.GA4004@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-08-14 13:34:12, David Rientjes wrote:
> Memcg aligns memory.limit_in_bytes to PAGE_SIZE as part of the resource counter
> since it makes no sense to allow a partial page to be charged.
> 
> As a result of the hugetlb cgroup using the resource counter, it is also aligned
> to PAGE_SIZE but makes no sense unless aligned to the size of the hugepage being
> limited.
> 
> Align hugetlb cgroup limit to hugepage size.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

huge_page_shift as proposed by Aneesh looks better.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/hugetlb_cgroup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -275,6 +275,8 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
>  		ret = res_counter_memparse_write_strategy(buf, &val);
>  		if (ret)
>  			break;
> +		val = ALIGN(val, 1 << (huge_page_order(&hstates[idx]) +
> +				       PAGE_SHIFT));
>  		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
>  		break;
>  	default:

-- 
Michal Hocko
SUSE Labs
