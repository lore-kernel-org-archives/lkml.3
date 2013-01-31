Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3AaSQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:16:55 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40552 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:16:53 -0500
Date: Thu, 31 Jan 2013 18:16:55 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 3/3] nsproxy: remove duplicate task_cred_xxx for user_ns
Message-ID: <20130131181655.GA19854@mail.hallyn.com>
References: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359624512-23469-3-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359624512-23469-3-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Yuanhan Liu (yuanhan.liu@linux.intel.com):
> We can use user_ns, which is also assigned from task_cred_xxx(tsk,
> user_ns), at the beginning of copy_namespaces().
> 
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  kernel/nsproxy.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 78e2ecb..b781e66 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -153,8 +153,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>  		goto out;
>  	}
>  
> -	new_ns = create_new_namespaces(flags, tsk,
> -				       task_cred_xxx(tsk, user_ns), tsk->fs);
> +	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
>  	if (IS_ERR(new_ns)) {
>  		err = PTR_ERR(new_ns);
>  		goto out;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
