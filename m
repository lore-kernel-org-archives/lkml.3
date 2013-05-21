Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3EUGQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:16:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:8223 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab3EUGQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:16:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,712,1363158000"; 
   d="scan'208";a="244468947"
Message-ID: <519B113C.6070006@linux.intel.com>
Date: Tue, 21 May 2013 09:16:28 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donanld.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com> <20130519102533.12527.12991.stgit@ladj378.jer.intel.com> <20130520162227.GD24555@two.firstfloor.org>
In-Reply-To: <20130520162227.GD24555@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 19:22, Andi Kleen wrote:
>> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
>> index f98ca63..cfcf0ea 100644
>> --- a/Documentation/networking/ip-sysctl.txt
>> +++ b/Documentation/networking/ip-sysctl.txt
>> @@ -19,6 +19,11 @@ ip_no_pmtu_disc - BOOLEAN
>>   	Disable Path MTU Discovery.
>>   	default FALSE
>>
>> +ip_low_latency_poll - INTEGER
>> +	Low latency busy poll timeout. (needs CONFIG_INET_LL_RX_POLL)
>> +	Approximate time in ms to spin waiting for packets on the device queue.
>> +	default 0
>
> Can you document the suggested value here?

ok
> Also I would add something like "may increase power usage"

:)
> The other thing I would add is a linuxmib statistic counter so that
> we can see the polling happens.

Yes,
I will add a counter for packets that were received through this path.

Eliezer
