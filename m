Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3LWIqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:46:00 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:24612 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:45:59 -0500
Message-ID: <52B7F81C.2080207@huawei.com>
Date: Mon, 23 Dec 2013 16:45:16 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/21] slight optimization of addr compare for some modules
References: <52B7C58B.9000602@huawei.com> <1387787324.22671.57.camel@joe-AO722>
In-Reply-To: <1387787324.22671.57.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/23 16:28, Joe Perches wrote:
> On Mon, 2013-12-23 at 13:09 +0800, Ding Tianhong wrote:
>> I use the recently added and possibly more efficient
>> ether_addr_equal_unaligned to instead of memcmp for slight
>> optimization.
> 
> Hi again.
> 
> These are the sorts of conversions that could be
> either ether_addr_equal or ether_addr_equal_unaligned
> depending on the existing alignment of the addresses
> being compared.
> 
> For instance, in patch 21:
> ---
> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> []
> @@ -131,12 +131,13 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
>  
>  static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
>  {
> -	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
> +	return a->sid == b->sid && ether_addr_equal_unaligned(a->remote,
> +		ther					      b->remote);
> ---
> 
> This could be ether_addr_equal instead as remote is after a be16
> and so remote is aligned to a u16.
> 
> include/uapi/linux/if_pppox.h:typedef __be16 sid_t;
> []
> include/uapi/linux/if_pppox.h:struct pppoe_addr {
> include/uapi/linux/if_pppox.h-  sid_t         sid;                    /* Session identifier */
> include/uapi/linux/if_pppox.h-  unsigned char remote[ETH_ALEN];       /* Remote address */
> include/uapi/linux/if_pppox.h-  char          dev[IFNAMSIZ];          /* Local device to use */
> include/uapi/linux/if_pppox.h-}; 
> 
> It's of course possible to convert the appropriate
> ether_addr_equal_unaligned uses to ether_addr_equal later.
> 
> 

Yes, I need to review the changes more clearly and then resend them, thanks.

Regards
Ding
> 


