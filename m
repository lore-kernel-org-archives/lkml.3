Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3FNGO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:14:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:11373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3FNGO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,863,1363158000"; 
   d="scan'208";a="329300998"
Message-ID: <51BAB4D9.2020803@linux.intel.com>
Date: Fri, 14 Jun 2013 09:14:49 +0300
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
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        sockperf-dev@googlegroups.com, Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v4 net-next 2/4] net: convert low latency sockets to sched_clock()
References: <20130614015638.3500.61523.stgit@ladj378.jer.intel.com>  <20130614015659.3500.48625.stgit@ladj378.jer.intel.com> <1371179569.3252.120.camel@edumazet-glaptop>
In-Reply-To: <1371179569.3252.120.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/2013 06:12, Eric Dumazet wrote:
> On Fri, 2013-06-14 at 04:57 +0300, Eliezer Tamir wrote:
>> Use sched_clock() instead of get_cycles().
>> We can use sched_clock() because we don't care much about accuracy.
>> Remove the dependency on X86_TSC
>>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>
>>
>> -static inline bool can_poll_ll(cycles_t end_time)
>> +static inline bool can_poll_ll(u64 end_time)
>>   {
>> -	return !time_after((unsigned long)get_cycles(),
>> +	return !time_after((unsigned long)sched_clock(),
>>   			    (unsigned long)end_time);
>>   }
>
> I do not really understand why you bother to have 64bit wide values,
> and then use these "unsigned long" casts here.
>
> On 32bit arches, this will really limit to 2^31 ns range.
>
> You should instead either :
> - use time_after_64() or
> - explicitly limit sysctl_net_ll_poll range

OK
