Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3CDIUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:20:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:42011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab3CDIUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:20:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="scan'208";a="293163305"
Message-ID: <5134592E.6050508@linux.intel.com>
Date: Mon, 04 Mar 2013 10:19:58 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <51344F54.8060809@gmail.com>
In-Reply-To: <51344F54.8060809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/03/2013 09:37, Cong Wang wrote:
> On 02/28/2013 01:55 AM, Eliezer Tamir wrote:
>>
>> Open issues:
>> 1. Find a way to avoid the need to change the sk and skb structs.
>> One big disadvantage of how we do this right now is that when a device is
>> removed, it's hard to prevent it from getting polled by a socket
>> which holds a stale reference.
>>
>> 2. How do we decide which sockets are eligible to do busy polling?
>> Do we add a socket option to control this?
>> How do we provide sane defaults while allowing flexibility and
>> performance?
>>
>> 3. Andi Kleen and HPA pointed out that using get_cycles() is not
>> portable.
>>
>> 4. How and where do we call ndo_ll_poll from the socket code?
>> One good place seems to be wherever the kernel puts the process to sleep,
>> waiting for more data, but this makes doing something intelligent about
>> poll (the system call) hard. From the perspective of how ndo_ll_poll
>> itself is implemented this does not seem to matter.
>>
>> 5. I would like to hear suggestions on naming conventions and where
>> to put the code that for now I have put in include/net/ll_poll.h
>>
>
>
> A dumb question: is bypassing tcpdump/netfilters/qdisc etc. what we
> always want? Isn't this a security issue?

We are not bypassing any of the regular stack checks/hooks, we call the 
normal netif_rx_skb().

Thanks,
Eliezer
