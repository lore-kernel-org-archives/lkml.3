Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaEVTje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:39:34 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:49839 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaEVTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:39:32 -0400
Message-ID: <537E526F.8060608@mentor.com>
Date: Thu, 22 May 2014 20:39:27 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vlad Yasevich <vyasevich@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, <kamal@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>, <edumazet@google.com>,
        <mszeredi@suse.cz>, <fw@strlen.de>
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com> <537E4F29.9080103@gmail.com>
In-Reply-To: <537E4F29.9080103@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 22 May 2014 19:39:31.0528 (UTC) FILETIME=[8D4FAC80:01CF75F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 20:25, Vlad Yasevich wrote:
> On 05/22/2014 03:07 PM, Jim Baxter wrote:
>>
>>     skb2 = skb_clone(skb, GFP_ATOMIC);
>>     if (skb2 == NULL)
>>         goto err;
>>
>>     if (!skb_pull(skb2, index)) {
>>         ret = -EOVERFLOW;
>>         goto err;
>>     }
> 
> This assumes that you original 16K packet is linear.  Is that
> always the case?
The packets within the original packet are linear, however they could be
in an arbitrary order because they are just offsets from the start of
the 16k skb.


> 
> This is the very same problem that I ran into with SCTP since it
> has similar code in it.  You can play games with truesize manually,
> but you have to be very careful here.
> 
> -vlad

I now think that the correct solution here is to create a new smaller
skb and copy the data from the sub packets into it.

Jim



