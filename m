Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaDVG3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:29:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3203 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDVG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:29:51 -0400
Message-ID: <53560C12.2050309@huawei.com>
Date: Tue, 22 Apr 2014 14:28:34 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: <davem@davemloft.net>, <tj@kernel.org>, <nhorman@tuxdriver.com>,
        <aris@redhat.com>, <dborkman@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netclassid_cgroup: explicitly init the early_init field
References: <1398144676-9739-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1398144676-9739-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 13:31, Jianyu Zhan wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
> 
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
> 

The initialization is redundant, and your reason is not reasonable.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

nack

> ---
>  net/core/netclassid_cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
> index 22931e1..1b07dca 100644
> --- a/net/core/netclassid_cgroup.c
> +++ b/net/core/netclassid_cgroup.c
> @@ -108,4 +108,5 @@ struct cgroup_subsys net_cls_cgrp_subsys = {
>  	.css_free		= cgrp_css_free,
>  	.attach			= cgrp_attach,
>  	.base_cftypes		= ss_files,
> +	.early_init		= 0,
>  };
> 

