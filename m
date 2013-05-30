Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3E3PaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:30:16 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:34950 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3PaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:30:11 -0400
Message-ID: <1369927806.2414.2.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] include/linux/skbuff.h: using '0xffff' instead of '~0U'
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chen Gang <gang.chen@asianux.com>
CC: <edumazet@google.com>, Pravin Shelar <pshelar@nicira.com>,
        <mgorman@suse.de>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 30 May 2013 16:30:06 +0100
In-Reply-To: <51A6EBC5.7040601@asianux.com>
References: <51A6EBC5.7040601@asianux.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19904.005
X-TM-AS-Result: No--14.199700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 14:03 +0800, Chen Gang wrote:
> Both 'transport_header' and 'mac_header' are u16, which are never equal
> to '~0U'.
> 
> So need use '0xffff' instead of '~0U'.

...and give this magic number a name?

Ben.

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

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

