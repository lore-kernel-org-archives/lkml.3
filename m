Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3FEPqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:46:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:25745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab3FEPqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,807,1363158000"; 
   d="scan'208";a="348644252"
Message-ID: <51AF5D5A.8030907@linux.intel.com>
Date: Wed, 05 Jun 2013 18:46:34 +0300
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
Subject: Re: [PATCH v9 net-next 2/7] net: add low latency socket poll
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>   <20130605103421.11172.82925.stgit@ladj378.jer.intel.com>  <1370445714.24311.268.camel@edumazet-glaptop>  <51AF59B0.6080101@linux.intel.com> <1370446760.24311.275.camel@edumazet-glaptop>
In-Reply-To: <1370446760.24311.275.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 18:39, Eric Dumazet wrote:
> On Wed, 2013-06-05 at 18:30 +0300, Eliezer Tamir wrote:
>> On 05/06/2013 18:21, Eric Dumazet wrote:

>>> It would also make sense to give end_time as a parameter, so that the
>>> polling() code could really give  a end_time for the whole duration of
>>> poll().
>>>
>>> (You then should test can_poll_ll(end_time) _before_ call to
>>> ndo_ll_poll())
>>
>> how would you handle a nonblocking operation in that case?
>> I guess if we have a socket option, then we don't need to handle none
>> blocking any diffrent, since the user specified exactly how much time to
>> waste polling. right?
>
> If the thread already spent 50us in the poll() system call, it for sure
> should not call any ndo_ll_poll(). This makes no more sense at this
> point.

what about a non-blocking read from a socket?
Right now we assume this means poll only once since the application will 
repeat as needed.

maybe add a "once" parameter that will cause sk_poll_ll() to ignore end 
time and only try once?
