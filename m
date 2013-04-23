Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3DWU1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:27:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:51980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3DWU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:27:42 -0400
Message-ID: <5176EEA8.1010507@infradead.org>
Date: Tue, 23 Apr 2013 13:27:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 23 (netlink)
References: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au> <5176CD22.6070906@infradead.org> <20130423.151949.1174398672200053405.davem@davemloft.net>
In-Reply-To: <20130423.151949.1174398672200053405.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/13 12:19, David Miller wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Tue, 23 Apr 2013 11:04:18 -0700
> 
>> On 04/23/13 01:00, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20130422:
>>>
>>> The net-next tree lost its build failure but gained another for which I
>>> applied a patch.
>>>
>>
>>
>> when CONFIG_NETLINK_MMAP is not enabled:
>>
>> net/netlink/diag.c: In function 'sk_diag_put_rings_cfg':
>> net/netlink/diag.c:28:17: error: 'struct netlink_sock' has no member named 'pg_vec_lock'
>> net/netlink/diag.c:29:29: error: 'struct netlink_sock' has no member named 'rx_ring'
>> net/netlink/diag.c:31:30: error: 'struct netlink_sock' has no member named 'tx_ring'
>> net/netlink/diag.c:33:19: error: 'struct netlink_sock' has no member named 'pg_vec_lock'
> 
> Thanks Randy, I'm testing out the following fix:
> 

Works for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> diff --git a/net/netlink/diag.c b/net/netlink/diag.c
> index 4e4aa47..1af2962 100644
> --- a/net/netlink/diag.c
> +++ b/net/netlink/diag.c
> @@ -7,6 +7,7 @@
>  
>  #include "af_netlink.h"
>  
> +#ifdef CONFIG_NETLINK_MMAP
>  static int sk_diag_put_ring(struct netlink_ring *ring, int nl_type,
>  			    struct sk_buff *nlskb)
>  {
> @@ -34,6 +35,12 @@ static int sk_diag_put_rings_cfg(struct sock *sk, struct sk_buff *nlskb)
>  
>  	return ret;
>  }
> +#else
> +static int sk_diag_put_rings_cfg(struct sock *sk, struct sk_buff *nlskb)
> +{
> +	return 0;
> +}
> +#endif
>  
>  static int sk_diag_dump_groups(struct sock *sk, struct sk_buff *nlskb)
>  {
> --


-- 
~Randy
