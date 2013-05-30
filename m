Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361Ab3E3J4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:56:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12483 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967560Ab3E3J4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:56:25 -0400
X-Spam-Score: -100.8
Message-ID: <51A72215.5060500@asianux.com>
Date: Thu, 30 May 2013 17:55:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: edumazet@google.com, Pravin Shelar <pshelar@nicira.com>, mgorman@suse.de
CC: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] include/linux/skbuff.h: using '0xffff' instead of '~0U'
References: <51A6EBC5.7040601@asianux.com>
In-Reply-To: <51A6EBC5.7040601@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems a good idea to "fgrep -rn '~0U'" all source code, and check
each one by one.

:-)


On 05/30/2013 02:03 PM, Chen Gang wrote:
> 
> Both 'transport_header' and 'mac_header' are u16, which are never equal
> to '~0U'.
> 
> So need use '0xffff' instead of '~0U'.
> 
> The related warning (with EXTRA_CFLAGS=-W ARCH=m68k for allmodconfig)
>   include/linux/skbuff.h:1587:2: warning: comparison is always true due to limited range of data type [-Wtype-limits]
>   ...
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/skbuff.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 2e0ced1..03ba058 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1581,7 +1581,7 @@ static inline void skb_set_inner_mac_header(struct sk_buff *skb,
>  }
>  static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
>  {
> -	return skb->transport_header != ~0U;
> +	return skb->transport_header != 0xffff;
>  }
>  
>  static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
> @@ -1624,7 +1624,7 @@ static inline unsigned char *skb_mac_header(const struct sk_buff *skb)
>  
>  static inline int skb_mac_header_was_set(const struct sk_buff *skb)
>  {
> -	return skb->mac_header != ~0U;
> +	return skb->mac_header != 0xffff;
>  }
>  
>  static inline void skb_reset_mac_header(struct sk_buff *skb)
> 


-- 
Chen Gang

Asianux Corporation
