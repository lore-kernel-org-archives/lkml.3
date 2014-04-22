Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaDVGrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:47:46 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62211 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVGrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <1398144620-9630-1-git-send-email-nasa4836@gmail.com>
References: <1398144620-9630-1-git-send-email-nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 14:47:42 +0800
Message-ID: <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
Subject: Re: [PATCH] hugetlb_cgroup: explicitly init the early_init field
From: Hillf Danton <dhillf@gmail.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:30 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
>
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
>
But other fields still missed, if any. Fair?

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/hugetlb_cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 595d7fd..b5368f8 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -405,4 +405,5 @@ struct cgroup_subsys hugetlb_cgrp_subsys = {
>         .css_alloc      = hugetlb_cgroup_css_alloc,
>         .css_offline    = hugetlb_cgroup_css_offline,
>         .css_free       = hugetlb_cgroup_css_free,
> +       .early_init     = 0,
>  };
> --
> 2.0.0-rc0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
