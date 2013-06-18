Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3FROux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:50:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:45924 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3FROuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:50:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="318861355"
Message-ID: <51C073C4.7040702@linux.intel.com>
Date: Tue, 18 Jun 2013 17:50:44 +0300
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
References: <20130618085759.10941.15811.stgit@ladj378.jer.intel.com>   <20130618085810.10941.55039.stgit@ladj378.jer.intel.com>  <1371551139.3252.249.camel@edumazet-glaptop>  <51C05FC1.4000201@linux.intel.com> <1371566148.3252.255.camel@edumazet-glaptop> <51C0728E.6060900@linux.intel.com>
In-Reply-To: <51C0728E.6060900@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/2013 17:45, Eliezer Tamir wrote:
> On 18/06/2013 17:35, Eric Dumazet wrote:
>> On Tue, 2013-06-18 at 16:25 +0300, Eliezer Tamir wrote:
>>
>>> One other thing,
>>> sock_poll() will only ll_poll if the flag was set _and_ the socket has a
>>> none-zero value in sk->sk_ll_usec so you still only poll on sockets
>>> that were enabled for LLS, not on every socket.
>>
>> But sockets are default enabled for LLS.
>>
>> sock_init_data()
>> {
>>     ...
>>     sk->sk_ll_usec      =   sysctl_net_ll_poll;
>>     ...
>> }
>
> Yes, if you want to globally enable.
>
> But now that we have the socket option, you can leave the global
> setting at 0 and only enable specific sockets via the socket option.
> (I have tested this with a modified sockperf and it works.)

I missed something, you need sysctl_net_ll_poll to be non-zero
for poll to even try.

So maybe add another sysctl value for poll?
maybe sysctl_net_ll_poll for poll
and sysctl_net_ll_read for socket reads?

