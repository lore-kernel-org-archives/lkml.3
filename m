Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3FKPhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:37:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:8268 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3FKPhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="351529801"
Message-ID: <51B74439.3030203@linux.intel.com>
Date: Tue, 11 Jun 2013 18:37:29 +0300
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
Subject: Re: [PATCH net-next 2/2] net:add socket option for low latency polling
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>  <20130611142438.17879.6389.stgit@ladj378.jer.intel.com> <1370961930.3252.32.camel@edumazet-glaptop>
In-Reply-To: <1370961930.3252.32.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 17:45, Eric Dumazet wrote:
> On Tue, 2013-06-11 at 17:24 +0300, Eliezer Tamir wrote:
>> adds a socket option for low latency polling.
>> This allows overriding the global sysctl value with a per-socket one.
>>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>>
>>
>> -static inline cycles_t ll_end_time(void)
>> +static inline cycles_t ll_end_time(struct sock *sk)
>>   {
>> -	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
>> +	return TSC_MHZ * ACCESS_ONCE(sk->sk_ll_usec) + get_cycles();
>>   }
>
> Hmm, sk_ll_usec is an unsigned int.

We changed it to an unsigned long in v7, I guess that was gratuitous.
Re-reading your comments on v6 2/5 I realize a cast would have sufficed.
Should I send a patch to revert it to an unsigned int?

Thanks,
Eliezer

