Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaEVUWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:22:03 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:53734 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaEVUV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:21:59 -0400
Message-ID: <537E5C63.7080607@mentor.com>
Date: Thu, 22 May 2014 21:21:55 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kamal@canonical.com>,
        <bhutchings@solarflare.com>, <edumazet@google.com>, <mszeredi@suse.cz>,
        <fw@strlen.de>
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com> <20140522.152146.2116142050088142989.davem@davemloft.net>
In-Reply-To: <20140522.152146.2116142050088142989.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 22 May 2014 20:21:58.0855 (UTC) FILETIME=[7BA2ED70:01CF75FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 20:21, David Miller wrote:
> From: Jim Baxter <jim_baxter@mentor.com>
> Date: Thu, 22 May 2014 20:07:41 +0100
> 
>> My questions are:
>>
>> 1) Which buffer size does truesize represent, is it the total buffer or
>> just the data related to the relevant skb?
>>
>> 2) If truesize is for the skb it is contained within should it be
>> updated during the call to skb_trim?
>>
>> 3) Why does the truesize default to 32960?
> 
> skb->truesize represents the total amount of memory that the SKB
> is holding up.
> 
> This is the size of the sk_buff metadata plus all of the buffer
> memory.
> 
> For example, if the buffer is using 16K buffer yet only 1500 of it is
> actually used for the packet, 16K is what should be plugged into the
> equation to compute truesize.
> 
> Otherwise it would be easy to compromise a system by sending lots of 1
> byte packets to a socket, even though the actual memory consumed by
> that "1 byte" packet is significantly larger.
> 

OK, so it is the value of the memory that has been allocated for the SKB.
If there are multiple clones for an skb all pointing at the same data,
will that distort the memory used when they all have the same truesize?

