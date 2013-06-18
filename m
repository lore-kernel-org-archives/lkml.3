Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3FRJMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:12:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:32044 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3FRJMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="351589010"
Message-ID: <51C02478.7020708@linux.intel.com>
Date: Tue, 18 Jun 2013 12:12:24 +0300
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
Subject: Re: [PATCH v2 net-next] net: poll/select low latency socket support
References: <20130618085759.10941.15811.stgit@ladj378.jer.intel.com>  <20130618085810.10941.55039.stgit@ladj378.jer.intel.com> <1371546510.3252.224.camel@edumazet-glaptop>
In-Reply-To: <1371546510.3252.224.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/2013 12:08, Eric Dumazet wrote:
> On Tue, 2013-06-18 at 11:58 +0300, Eliezer Tamir wrote:
>> select/poll busy-poll support.
>>
>
>
>>    */
>> -static inline u64 ll_end_time(struct sock *sk)
>> +static inline u64 ll_sk_end_time(struct sock *sk)
>>   {
>> -	u64 end_time = ACCESS_ONCE(sk->sk_ll_usec);
>> -
>> -	/* we don't mind a ~2.5% imprecision
>> -	 * sk->sk_ll_usec is a u_int so this can't overflow
>> -	 */
>> -	end_time = (end_time << 10) + sched_clock();
>> +	return (ACCESS_ONCE(sk->sk_ll_usec) << 10) + sched_clock();
>> +}
>>
>
> This is the fourth time you try to introduce an overflow in this code.
>
> (same for ll_end_time())

sorry,
Please review the rest of the patch to see if you have any other comments.
