Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaJGUHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbaJGUHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:07:40 -0400
Date: Tue, 7 Oct 2014 16:06:27 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        manfred@colorfullife.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: compat_mq  sizeof() instead of sizeof
Message-ID: <20141007200626.GA21886@t510.redhat.com>
References: <1412266828-4274-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412266828-4274-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 05:20:28PM +0100, Paul McQuade wrote:
> added a parenthesis for sizeof function
>

This log message could use some enhancement (just a nit)

Other than that:

Acked-by: Rafael Aquini <aquini@redhat.com>

> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  ipc/compat_mq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
> index ef6f91c..27496d9 100644
> --- a/ipc/compat_mq.c
> +++ b/ipc/compat_mq.c
> @@ -25,7 +25,7 @@ struct compat_mq_attr {
>  static inline int get_compat_mq_attr(struct mq_attr *attr,
>  			const struct compat_mq_attr __user *uattr)
>  {
> -	if (!access_ok(VERIFY_READ, uattr, sizeof *uattr))
> +	if (!access_ok(VERIFY_READ, uattr, sizeof(*uattr)))
>  		return -EFAULT;
>  
>  	return __get_user(attr->mq_flags, &uattr->mq_flags)
> @@ -37,7 +37,7 @@ static inline int get_compat_mq_attr(struct mq_attr *attr,
>  static inline int put_compat_mq_attr(const struct mq_attr *attr,
>  			struct compat_mq_attr __user *uattr)
>  {
> -	if (clear_user(uattr, sizeof *uattr))
> +	if (clear_user(uattr, sizeof(*uattr)))
>  		return -EFAULT;
>  
>  	return __put_user(attr->mq_flags, &uattr->mq_flags)
> -- 
> 1.9.1
> 
