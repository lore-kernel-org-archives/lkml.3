Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3FCNxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:53:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:34859 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab3FCNxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,793,1363158000"; 
   d="scan'208";a="311565093"
Message-ID: <51AC9FD8.1080400@linux.intel.com>
Date: Mon, 03 Jun 2013 16:53:28 +0300
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
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v8 net-next 2/7] net: add low latency socket poll
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>  <20130603080128.18273.2408.stgit@ladj378.jer.intel.com> <1370264704.24311.129.camel@edumazet-glaptop>
In-Reply-To: <1370264704.24311.129.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 16:05, Eric Dumazet wrote:
> On Mon, 2013-06-03 at 11:01 +0300, Eliezer Tamir wrote:
>> --- a/net/core/sysctl_net_core.c
>> +++ b/net/core/sysctl_net_core.c
>> @@ -19,6 +19,7 @@
>>   #include <net/ip.h>
>>   #include <net/sock.h>
>>   #include <net/net_ratelimit.h>
>> +#include <net/ll_poll.h>
>>
>>   static int one = 1;
>>
>> @@ -284,6 +285,15 @@ static struct ctl_table net_core_table[] = {
>>   		.proc_handler	= flow_limit_table_len_sysctl
>>   	},
>>   #endif /* CONFIG_NET_FLOW_LIMIT */
>> +#ifdef CONFIG_NET_LL_RX_POLL
>> +	{
>> +		.procname	= "low_latency_poll",
>> +		.data		= &sysctl_net_ll_poll,
>> +		.maxlen		= sizeof(unsigned long),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec
>
> proc_doulongvec_minmax

Thank you.
