Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3LQP5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:57:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3LQP5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:57:47 -0500
Message-ID: <1387295792.23829.86.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 1/2] audit: print error message when fail to create
 audit socket
From: Eric Paris <eparis@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, rgb@redhat.com
Date: Tue, 17 Dec 2013 10:56:32 -0500
In-Reply-To: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 11:10 +0800, Gao feng wrote:
> print the error message and then return -ENOMEM.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Haha.  If it's NULL return.  No no, if it's REALLY null audit_panic().

Acked-by: Eric Paris <eparis@redhat.com>
> ---
>  kernel/audit.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 2a0ed0b..041b951 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1083,12 +1083,11 @@ static int __net_init audit_net_init(struct net *net)
>  	pr_info("audit: initializing netlink socket in namespace\n");
>  
>  	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
> -	if (aunet->nlsk == NULL)
> -		return -ENOMEM;
> -	if (!aunet->nlsk)
> +	if (aunet->nlsk == NULL) {
>  		audit_panic("cannot initialize netlink socket in namespace");
> -	else
> -		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> +		return -ENOMEM;
> +	}
> +	aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
>  	return 0;
>  }
>  


