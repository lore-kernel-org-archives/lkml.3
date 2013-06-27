Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3F0IBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:01:25 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43522 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3F0IBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:01:23 -0400
Message-ID: <1372320082.3301.217.camel@edumazet-glaptop>
Subject: Re: [RFC Patch net-next 3/5] inetpeer: use generic union inet_addr
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 01:01:22 -0700
In-Reply-To: <1372315398-19683-4-git-send-email-amwang@redhat.com>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-4-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:43 +0800, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  include/net/inetpeer.h |   29 +++++----------
>  net/ipv4/inetpeer.c    |   35 +++++++++++-------
>  net/ipv4/tcp_metrics.c |   92 ++++++++++++++++++++----------------------------
>  3 files changed, 68 insertions(+), 88 deletions(-)
> 
> diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
> index 53f464d..7ec33fb 100644
> --- a/include/net/inetpeer.h
> +++ b/include/net/inetpeer.h
> @@ -13,24 +13,13 @@
>  #include <linux/spinlock.h>
>  #include <linux/rtnetlink.h>
>  #include <net/ipv6.h>
> +#include <net/inet_addr.h>
>  #include <linux/atomic.h>
>  
> -struct inetpeer_addr_base {
> -	union {
> -		__be32			a4;
> -		__be32			a6[4];
> -	};
> -};
> -
> -struct inetpeer_addr {
> -	struct inetpeer_addr_base	addr;
> -	__u16				family;
> -};
> -
>  struct inet_peer {
>  	/* group together avl_left,avl_right,v4daddr to speedup lookups */
>  	struct inet_peer __rcu	*avl_left, *avl_right;
> -	struct inetpeer_addr	daddr;
> +	union inet_addr		daddr;

Please compare sizeof(struct inetpeer_addr) and sizeof(union inet_addr)

If I am not mistaken, its 20 bytes instead of 28

Yes, sockaddr_in6 is a bit bloated...


