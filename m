Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3FRNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:25:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:21754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3FRNZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:25:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="355508806"
Message-ID: <51C05FC1.4000201@linux.intel.com>
Date: Tue, 18 Jun 2013 16:25:21 +0300
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
References: <20130618085759.10941.15811.stgit@ladj378.jer.intel.com>  <20130618085810.10941.55039.stgit@ladj378.jer.intel.com> <1371551139.3252.249.camel@edumazet-glaptop>
In-Reply-To: <1371551139.3252.249.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/2013 13:25, Eric Dumazet wrote:
> On Tue, 2013-06-18 at 11:58 +0300, Eliezer Tamir wrote:

>> @@ -731,7 +755,11 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
>>   			mask = DEFAULT_POLLMASK;
>>   			if (f.file->f_op && f.file->f_op->poll) {
>>   				pwait->_key = pollfd->events|POLLERR|POLLHUP;
>> +				if (try_ll)
>> +					pwait->_key |= POLL_LL;
>
> Well, why enforce POLL_LL ?
>
> Sure we do this for select() as the API doesn't allow us to add the LL
> flag, but poll() can do that.
>
> An application might set POLL_LL flag only on selected fds.

One other thing,
sock_poll() will only ll_poll if the flag was set _and_ the socket has a
none-zero value in sk->sk_ll_usec so you still only poll on sockets
that were enabled for LLS, not on every socket.

-Eliezer
