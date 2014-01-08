Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaAHAxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:53:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaAHAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:53:36 -0500
Date: Tue, 7 Jan 2014 16:53:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, rgb@redhat.com,
        eparis@redhat.com
Subject: Re: [PATCH 1/2] audit: print error message when fail to create
 audit socket
Message-Id: <20140107165335.c276557412291786d745e0ab@linux-foundation.org>
In-Reply-To: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 11:10:41 +0800 Gao feng <gaofeng@cn.fujitsu.com> wrote:

> print the error message and then return -ENOMEM.
> 
> ...
>
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

What kernel version are these against?  Something ancient, I expect -
audit_net_init() doesn't exist.

Please check current kernels, redo and resend the patches if anything
needs changing?

