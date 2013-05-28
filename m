Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab3E1IEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:04:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:53654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290Ab3E1IEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:04:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,756,1363158000"; 
   d="scan'208";a="344236594"
Message-ID: <51A46507.3060901@linux.intel.com>
Date: Tue, 28 May 2013 11:04:23 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v5 net-next 2/5] net: implement support for low latency
 socket polling
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>  <20130527074411.29882.88391.stgit@ladj378.jer.intel.com> <1369700781.3301.497.camel@edumazet-glaptop>
In-Reply-To: <1369700781.3301.497.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/2013 03:26, Eric Dumazet wrote:
> On Mon, 2013-05-27 at 10:44 +0300, Eliezer Tamir wrote:

>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 66772cf..c7c3ea6 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -281,6 +281,7 @@ struct cg_proto;
>>     *	@sk_error_report: callback to indicate errors (e.g. %MSG_ERRQUEUE)
>>     *	@sk_backlog_rcv: callback to process the backlog
>>     *	@sk_destruct: called at sock freeing time, i.e. when all refcnt == 0
>> +  *	@sk_napi_id: id of the last napi context to receive data for sk
>>    */
>>   struct sock {
>>   	/*
>> @@ -399,6 +400,9 @@ struct sock {
>>   	int			(*sk_backlog_rcv)(struct sock *sk,
>>   						  struct sk_buff *skb);
>>   	void                    (*sk_destruct)(struct sock *sk);
>> +#ifdef CONFIG_NET_LL_RX_POLL
>> +	unsigned int		sk_napi_id;
>> +#endif
>>   };
>
> I believe this is a bad choice for data locality.
>
> I would rather move it in the same cache line than sk_rxhash

I will move it to right after sk_rxhash.

-Eliezer
