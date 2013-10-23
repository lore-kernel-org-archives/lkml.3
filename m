Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3JWNCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:02:50 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62665 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3JWNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:02:49 -0400
Message-ID: <1382533364.7572.15.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: -27% netperf TCP_STREAM regression by "tcp_memcontrol: Kill
 struct tcp_memcontrol"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>, fengguang.wu@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Oct 2013 06:02:44 -0700
In-Reply-To: <20131023122543.GH5132@cpaasch-mac>
References: <20131022214129.GB2715@localhost>
	 <20131022.180023.1141845387743361648.davem@davemloft.net>
	 <87k3h461ql.fsf@tw-ebiederman.twitter.com>
	 <20131023122543.GH5132@cpaasch-mac>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 14:25 +0200, Christoph Paasch wrote:

> may it be the below?
> 
> 
> Cheers,
> Christoph
> 
> ----
> From: Christoph Paasch <christoph.paasch@uclouvain.be>
> Subject: [PATCH] Fix: Dereference pointer-value of sk_prot->memory_pressure
> 
> 2e685cad57 (tcp_memcontrol: Kill struct tcp_memcontrol) falsly modified
> the access to memory_pressure of sk->sk_prot->memory_pressure. The patch
> did modify the memory_pressure-field of struct cg_proto, but not the one
> of struct proto.
> 
> So, the access to sk_prot->memory_pressure should not be changed.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
> ---
>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index c93542f..e3a18ff 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1137,7 +1137,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
>         if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
>                 return !!sk->sk_cgrp->memory_pressure;
> 
> -       return !!sk->sk_prot->memory_pressure;
> +       return !!*sk->sk_prot->memory_pressure;
>  }
> 
>  static inline void sk_leave_memory_pressure(struct sock *sk)

Nice catch, thanks !

Acked-by: Eric Dumazet <edumazet@google.com>



