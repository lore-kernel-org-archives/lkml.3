Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3IWB76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:59:58 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40280 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3IWB74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:59:56 -0400
Message-ID: <523FA098.9050200@gmail.com>
Date: Mon, 23 Sep 2013 11:59:52 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] ping.h: Remove extern from function prototypes
References: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
In-Reply-To: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/13 03:32, Joe Perches wrote:
> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This seems like a lot of code churn for very little benefit. At a quick
glance:

  git grep extern include/ | wc -l
  11427

Not all of those will need to be removed, but that is still a huge
number to change, and doesn't include extern usage in C files or local
headers. You are probably never going to remove all the instances, so
what is the point of just randomly doing a handful?

~Ryan

> ---
>  include/net/ping.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/ping.h b/include/net/ping.h
> index 5db0224..3f67704 100644
> --- a/include/net/ping.h
> +++ b/include/net/ping.h
> @@ -103,8 +103,8 @@ void ping_seq_stop(struct seq_file *seq, void *v);
>  int ping_proc_register(struct net *net, struct ping_seq_afinfo *afinfo);
>  void ping_proc_unregister(struct net *net, struct ping_seq_afinfo *afinfo);
>  
> -extern int __init ping_proc_init(void);
> -extern void ping_proc_exit(void);
> +int __init ping_proc_init(void);
> +void ping_proc_exit(void);
>  #endif
>  
>  void __init ping_init(void);
> 

