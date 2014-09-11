Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaIKQa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:30:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52825 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaIKQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:30:55 -0400
Date: Thu, 11 Sep 2014 16:30:48 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RESEND][PATCH] userns: use marco instead of magic number for
 max userns level
Message-ID: <20140911163048.GF24386@ubuntumail>
References: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> Use marco instead of magic number
> for max user namespace level.
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  kernel/user_namespace.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0..5435489 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -47,6 +47,8 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  	cred->user_ns = user_ns;
>  }
>  
> +#define MAX_USER_NS_LEVEL 32
> +
>  /*
>   * Create a new user namespace, deriving the creator from the user in the
>   * passed credentials, and replacing that user with the new root user for the
> @@ -62,7 +64,7 @@ int create_user_ns(struct cred *new)
>  	kgid_t group = new->egid;
>  	int ret;
>  
> -	if (parent_ns->level > 32)
> +	if (parent_ns->level > MAX_USER_NS_LEVEL)
>  		return -EUSERS;
>  
>  	/*
> -- 
> 1.9.0
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
