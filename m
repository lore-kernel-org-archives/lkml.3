Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3JMD67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 23:58:59 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60543 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3JMD66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 23:58:58 -0400
Message-ID: <1381636737.3392.29.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH net-next] fib_trie: remove duplicated rcu lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: baker.kernel@gmail.com
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Oct 2013 20:58:57 -0700
In-Reply-To: <1381623217-5883-1-git-send-email-baker.kernel@gmail.com>
References: <1381623217-5883-1-git-send-email-baker.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-13 at 08:13 +0800, baker.kernel@gmail.com wrote:
> From: "baker.zhang" <baker.kernel@gmail.com>
> 
> fib_table_lookup has included the rcu lock protection.
> 
> Signed-off-by: baker.zhang <baker.kernel@gmail.com>
> ---
>  net/ipv4/fib_frontend.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index b3f627a..0e9127d 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -170,12 +170,10 @@ static inline unsigned int __inet_dev_addr_type(struct net *net,
>  	local_table = fib_get_table(net, RT_TABLE_LOCAL);
>  	if (local_table) {
>  		ret = RTN_UNICAST;
> -		rcu_read_lock();
>  		if (!fib_table_lookup(local_table, &fl4, &res, FIB_LOOKUP_NOREF)) {
>  			if (!dev || dev == res.fi->fib_dev)
>  				ret = res.type;
>  		}
> -		rcu_read_unlock();
>  	}

This looks very wrong.

res.fi could disappear, and we crash.




