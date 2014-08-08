Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaHHFrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:47:47 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55948 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaHHFrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:47:46 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage size
In-Reply-To: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Fri, 08 Aug 2014 11:17:37 +0530
Message-ID: <87sil7mt1i.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080805-2674-0000-0000-0000014E0259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

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

you can use  1UL << huge_page_shift(hstate); ?

>  		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
>  		break;
>  	default:
>

-aneesh

