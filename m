Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3FKJ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:29:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:23862 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3FKJ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,844,1363158000"; 
   d="scan'208";a="315224455"
Message-ID: <51B6EDE8.7020009@linux.intel.com>
Date: Tue, 11 Jun 2013 12:29:12 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v10 net-next 0/6] net: low latency Ethernet device polling
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>  <20130610.134116.1913599114372510768.davem@davemloft.net>  <51B68AA6.1050105@linux.intel.com>  <20130610.212443.1096102996038709384.davem@davemloft.net>  <51B6C87B.70101@linux.intel.com> <1370935964.3252.24.camel@edumazet-glaptop>
In-Reply-To: <1370935964.3252.24.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 10:32, Eric Dumazet wrote:
> On Tue, 2013-06-11 at 09:49 +0300, Eliezer Tamir wrote:
>
>> I would like to hear opinions on what needs to be added to make this
>> feature complete.
>>
>> The list I have so far is:
>> 1. add a socket option
>
> Yes, please. I do not believe all sockets on the machine are candidate
> for low latency. In fact very few of them should be, depending on the
> number of cpu and/or RX queues.

I have a patch for that, along a patch for sockperf I will use for
testing.
One I will test it some more, I will send it in.

>> 3. support for epoll
>
> For this one, I honestly do not know how to proceed.
>
> epoll Edge Trigger model is driven by the wakeups events.
>
> The wakeups come from frames being delivered by the NIC (for UDP/TCP
> sockets)
>
> If epoll_wait() has to scan the list of epitem to be able to perform the
> llpoll callback, it will be too slow : We come back to poll() model,
> with O(N) execution time.
>
> Ideally we would have to callback llpoll not from the tcp_poll(), but
> right before putting current thread in wait mode.

We have a few ideas, I will do a POC and see if any of them actually
work.

One thing that would really help is information about use-cases that
people care about:

Number and type of sockets, how active are they.
How many active Ethernet ports are there.
Can bulk and low latency traffic be steered to separate cores or
separated in any other way.

Thanks,
Eliezer
