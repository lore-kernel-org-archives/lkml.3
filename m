Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaDVGWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:22:49 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:4820 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaDVGWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:22:43 -0400
Message-ID: <53560A9A.4020800@huawei.com>
Date: Tue, 22 Apr 2014 14:22:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: explicitly init the early_init field
References: <1398144449-9325-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1398144449-9325-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 13:27, Jianyu Zhan wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
> 
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
> 

If you think this is the right thing to do, you can apply the same reason
to the initialization of other structures in the whole kernel tree.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

nack

> ---
>  kernel/cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 559f822..f23cb67 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -5325,5 +5325,6 @@ struct cgroup_subsys debug_cgrp_subsys = {
>  	.css_alloc = debug_css_alloc,
>  	.css_free = debug_css_free,
>  	.base_cftypes = debug_files,
> +	.early_init = 0,
>  };
>  #endif /* CONFIG_CGROUP_DEBUG */
> 

