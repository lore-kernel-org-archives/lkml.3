Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3EUTco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:32:44 -0400
Received: from git.silcnet.org ([81.89.56.81]:34928 "EHLO git.silcnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3EUTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:32:42 -0400
Date: Tue, 21 May 2013 21:31:51 +0200 (CEST)
From: Pekka Riikonen <priikone@iki.fi>
X-X-Sender: priikone@git.silcnet.org
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, eliezer.tamir@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 1/4] net: implement support for low latency
 socket polling
In-Reply-To: <20130521.114921.460497085402760002.davem@davemloft.net>
Message-ID: <alpine.GSO.2.00.1305212123120.15328@git.silcnet.org>
References: <519B2237.20204@linux.intel.com> <1369142926.3301.213.camel@edumazet-glaptop> <alpine.GSO.2.00.1305211855120.9230@git.silcnet.org> <20130521.114921.460497085402760002.davem@davemloft.net>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013, David Miller wrote:

> From: Pekka Riikonen <priikone@iki.fi>
> Date: Tue, 21 May 2013 19:02:19 +0200 (CEST)
>
>> On Tue, 21 May 2013, Eric Dumazet wrote:
>>
>> : > > Alternatively, use a napi_id instead of a pointer.
>> : >
>> : > I'm not sure I understand what you propose.
>> :
>> : Oh well.
>> :
>> : To get a pointer to a struct net_device, we can use ifindex, and do a
>> : rcu lookup into a hash table to get the net_device. We do not need
>> : {pointer,ifindex} but {ifindex} is enough
>> :
>> : My suggestion is to not have skb->skb_ref but skb->napi_index : Its safe
>> : to copy its value from skb->napi_index to sk->napi_index without
>> : refcounting.
>> :
>> : All NAPI need to get a unique napi_index, and be inserted in a hash
>> : table for immediate/fast lookup.
>> :
>> Maybe even that's not needed.  Couldn't skb->queue_mapping give the
>> correct NAPI instance in multiqueue nics?  The NAPI instance could be made
>> easily available from skb->dev.  In any case an index is much better than
>> a new pointer.
>
> Queue mapping is more volatile, and consider layered devices.
>
Yes, true.  The napi_index then is probably the way to go.  Main thing for 
me is that it doesn't increase skb size when in union with dma_cookie (skb 
has been growing lately).

 	Pekka

