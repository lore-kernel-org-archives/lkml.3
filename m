Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719Ab3E2OCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:02:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:26956 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966645Ab3E2OCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="309528485"
Message-ID: <51A60A42.20905@linux.intel.com>
Date: Wed, 29 May 2013 17:01:38 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>  <20130529063935.27486.18610.stgit@ladj378.jer.intel.com> <1369834647.5109.15.camel@edumazet-glaptop>
In-Reply-To: <1369834647.5109.15.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 16:37, Eric Dumazet wrote:
> On Wed, 2013-05-29 at 09:39 +0300, Eliezer Tamir wrote:

>> +static inline unsigned long ll_end_time(void)
>> +{
>> +	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
>> +}
>
> This can overflow.
>
> Multiply is giving 32bits, as tsc_khz is an int, and sysctl_net_ll_poll
> is an int.
>
> unsigned long sysctl_net_ll_poll ?
OK

> Also, if we want this to work on i386, the correct type to use for
> ll_end_time(void) would be cycles_t

OK
I would be really surprised if someone uses this on an i386, but I guess 
you never know.

Thanks!
-Eliezer
