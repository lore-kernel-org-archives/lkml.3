Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3LPHXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:23:48 -0500
Received: from asix.com.tw ([113.196.140.82]:51244 "EHLO freebsd1.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813Ab3LPHXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:23:46 -0500
Message-ID: <52AEA3A8.2020906@asix.com.tw>
Date: Mon, 16 Dec 2013 14:54:32 +0800
From: Freddy Xin <freddy@asix.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether
 reserving NET_IP_ALIGN bytes for an SKB.
References: <1386926708-2343-1-git-send-email-freddy@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年12月13日 18:36, David Laight wrote:
>> From: freddy@asix.com.tw
> ...
>> -	skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
>> +	if (dev->driver_info->flags & FLAG_HW_IPALIGN)
>> +		skb = __netdev_alloc_skb(dev->net, size, flags);
>> +	else
>> +		skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
> Given the definition:
> static inline struct sk_buff *__netdev_alloc_skb_ip_align(struct net_device *dev,
>                  unsigned int length, gfp_t gfp)
> {
>          struct sk_buff *skb = __netdev_alloc_skb(dev, length + NET_IP_ALIGN, gfp);
>
>          if (NET_IP_ALIGN && skb)
>                  skb_reserve(skb, NET_IP_ALIGN);
>          return skb;
> }
>
> It really ought to be possible to code that without an extra conditional.
>
> 	David
>
>
>
>
The AX88179_178A driver do need to know the value of NET_IP_ALIGN
to determine whether enabling the feature that makes IP header align
on a dword-aligned address, but according to the comments from David
Miller, I need to consider all situations, not just for the case that
NET_IP_ALIGN is zero, so the condition added in rx_submit is just used to
determine whether reserving NET_IP_ALIGN bytes for each SKB.

Freddy
