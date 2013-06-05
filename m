Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3FEPrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:47:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:18006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3FEPrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,807,1363158000"; 
   d="scan'208";a="348644793"
Message-ID: <51AF5D82.1090308@linux.intel.com>
Date: Wed, 05 Jun 2013 18:47:14 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v9 net-next 5/7] net: simple poll/select low latency socket
 poll
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>   <20130605103452.11172.31453.stgit@ladj378.jer.intel.com>  <1370439054.24311.248.camel@edumazet-glaptop>  <51AF401C.2030506@linux.intel.com> <1370445606.24311.265.camel@edumazet-glaptop>
In-Reply-To: <1370445606.24311.265.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 18:20, Eric Dumazet wrote:
> On Wed, 2013-06-05 at 16:41 +0300, Eliezer Tamir wrote:
>> On 05/06/2013 16:30, Eric Dumazet wrote:
>
>>> I am a bit uneasy with this one, because an applicatio polling() on one
>>> thousand file descriptors using select()/poll(), will call sk_poll_ll()
>>> one thousand times.
>>
>> But we call sk_poll_ll() with nonblock set, so it will only test once
>> for each socket and not loop.
>>
>> I think this is not as bad as it sounds.
>> We still honor the time limit on how long to poll.
>
> We still call ndo_ll_poll() a thousand times, and probably do a
> spinlock/unlock a thousand times in the driver.
>
> I would definitely be convinced if you give us some performance numbers
> of a poll() on a thousand tcp sockets for example.

So with 1000 sockets this is defiantly not a win
sockperf with 1000 udp sockets

sysctl   50         0
select 178.5 us / 130.0 us
poll   188.6 us / 130.0 us

