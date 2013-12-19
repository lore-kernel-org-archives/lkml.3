Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3LSDOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 22:14:36 -0500
Received: from asix.com.tw ([113.196.140.82]:35988 "EHLO freebsd1.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707Ab3LSDOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 22:14:35 -0500
Message-ID: <52B2648C.80500@asix.com.tw>
Date: Thu, 19 Dec 2013 11:14:20 +0800
From: Freddy Xin <freddy@asix.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether
 reserving NET_IP_ALIGN bytes for an SKB.
References: <1386926708-2343-1-git-send-email-freddy@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com> <52AEA3A8.2020906@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B7490@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7490@saturn3.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年12月16日 18:09, David Laight wrote:
>> I was thinking of something like: skb = netdev_alloc_skb(dev, length 
>> + dev->skb_align, gfp); if (NET_IP_ALIGN && skb && !(ev->driver_flags 
>> & FLAG_HW_IPALIGN)) skb_reserve(skb, NET_IP_ALIGN); It might even be 
>> reasonable to remove the length adjustment - provided that all the 
>> later code uses the skb length. David 

Thanks for your advice.
In the way you advised, does the dev->skb_align equal
to NET_IP_ALIGN in the case that HW doesn't supoort
IP alignment?
In other words, dev->skb_align should be initialized to
NET_IP_ALIGN in USBNET, and I can change its value to
0 in AX88179_178A driver, right?

     Freddy

