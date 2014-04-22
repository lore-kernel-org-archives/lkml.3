Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaDVLDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:03:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41796 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaDVLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:03:33 -0400
Date: Tue, 22 Apr 2014 07:02:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: davem@davemloft.net, lizefan@huawei.com, tj@kernel.org, aris@redhat.com,
        dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netclassid_cgroup: explicitly init the early_init field
Message-ID: <20140422110236.GC17116@hmsreliant.think-freely.org>
References: <1398144676-9739-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398144676-9739-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:31:16PM +0800, Jianyu Zhan wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
> 
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
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
> -- 
> 2.0.0-rc0
> 
> 
Agreed, this doesn't make sense, early_init is default assigned to zero.  What
problem are you trying to solve?
Neil

