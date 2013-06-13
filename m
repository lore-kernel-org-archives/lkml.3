Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab3FMQxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:53:22 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:8513 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569Ab3FMQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:53:19 -0400
Message-ID: <1371142391.2246.4.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 3/3] skbuff: Added new helper function
 skb_cow_clone_head.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Dave Wiltshire <david.wiltshire@gmx.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsujir@broadcom.com>,
        <mchan@broadcom.com>, <rmody@brocade.com>, <jcliburn@gmail.com>,
        <chris.snook@gmail.com>, <jeffrey.t.kirsher@intel.com>,
        <bruce.w.allan@intel.com>, <alexander.h.duyck@intel.com>,
        <cooldavid@cooldavid.org>, <linux-driver@qlogic.com>,
        <linux-wimax@intel.com>, <wimax@linuxwimax.org>,
        <linux-wireless@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <edumazet@google.com>, <dev@openvswitch.org>,
        <jhs@mojatatu.com>
Date: Thu, 13 Jun 2013 17:53:11 +0100
In-Reply-To: <1371040811-8319-2-git-send-email-david.wiltshire@gmx.com>
References: <1371030906-2396-1-git-send-email-david.wiltshire@gmx.com>
	 <1371040811-8319-1-git-send-email-david.wiltshire@gmx.com>
	 <1371040811-8319-2-git-send-email-david.wiltshire@gmx.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19940.002
X-TM-AS-Result: No--7.607000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 22:40 +1000, Dave Wiltshire wrote:
> In a few different drivers there is a check of (skb_cloned &&
> !skb_clone_writable) before then using pskb_expand_head to copy the skb
> if that is required. There are already some skb_cow_* functions for
> other conditions, so added this one and changed the call sites.
> 
> Signed-off-by: Dave Wiltshire <david.wiltshire@gmx.com>
> ---
>  include/linux/skbuff.h    |   14 ++++++++++++++
>  net/core/dev.c            |    8 ++------
>  net/openvswitch/actions.c |   22 +++++++---------------
>  net/sched/act_csum.c      |    8 ++------
>  net/sched/act_nat.c       |   18 +++++-------------
>  5 files changed, 30 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index a7393ad..7d18541 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2154,6 +2154,20 @@ static inline int skb_cow_head(struct sk_buff *skb, unsigned int headroom)
>  }
>  
>  /**
> + * skb_cow_clone_head

This is a missing a short description after the name.

Ben.

> + * @skb: buffer to cow
> + * @len: length up to which to write
> + *
> + * This function is identical to skb_cow and sb_cow_head except that we
> + * replace the skb_cloned check by skb_cloned && !skb_clone_writable.
> + *
> + */
> +static inline int skb_cow_clone_head(struct sk_buff *skb, unsigned int len)
> +{
> +	return __skb_cow(skb, 0, skb_cloned(skb) && !skb_clone_writable(skb, len));
> +}
[...]

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

