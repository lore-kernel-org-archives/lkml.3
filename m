Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaHIKF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 06:05:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55856 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHIKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 06:05:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v2] mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage size
In-Reply-To: <alpine.DEB.2.02.1408081507180.15603@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com> <alpine.DEB.2.02.1408081507180.15603@chino.kir.corp.google.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Sat, 09 Aug 2014 15:35:47 +0530
Message-ID: <87mwbem0zo.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080910-9574-0000-0000-00000086F2DD
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
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  v2: use huge_page_order() per Aneesh
>      Sorry for not cc'ing you initially, get_maintainer.pl failed me
>
>  mm/hugetlb_cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -275,6 +275,7 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
>  		ret = res_counter_memparse_write_strategy(buf, &val);
>  		if (ret)
>  			break;
> +		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));

Do we really need ULL ? max value should fit in unsigned long right ?

>  		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
>  		break;
>  	default:

