Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3FLM7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:59:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:53722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3FLM7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:59:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,852,1363158000"; 
   d="scan'208";a="348689045"
Message-ID: <51B87091.4050205@linux.intel.com>
Date: Wed, 12 Jun 2013 15:58:57 +0300
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
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 3/3] net: add socket option for low latency
 polling
References: <20130612111942.19288.12131.stgit@ladj378.jer.intel.com>  <20130612112016.19288.86849.stgit@ladj378.jer.intel.com> <1371041065.3252.59.camel@edumazet-glaptop> <51B86FA3.1030306@linux.intel.com>
In-Reply-To: <51B86FA3.1030306@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 15:54, Eliezer Tamir wrote:
> On 12/06/2013 15:44, Eric Dumazet wrote:
>> On Wed, 2013-06-12 at 14:20 +0300, Eliezer Tamir wrote:
>>> adds a socket option for low latency polling.
>>> This allows overriding the global sysctl value with a per-socket one.
>>>
>>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>>> ---
>>
>> It seems EXPORT_SYMBOL_GPL(sysctl_net_ll_poll) can now be removed ?
>
> I think we would need it for poll.
>
> Poll needs a way that is not dependent on any individual socket to know
> how long to busy-wait, since we have to know it before we poll any
> individual socket.

Or maybe, since the time constants seem to be different, we should have
two separate sysctl values, one for read and another for poll?

(and then the one for read does not need to be exported to modules.)
