Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3GJD3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:29:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:65218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab3GJD3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:29:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1033,1363158000"; 
   d="scan'208";a="367794303"
Message-ID: <51DCD50C.6070606@linux.intel.com>
Date: Wed, 10 Jul 2013 06:29:16 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        dwmw2@infradead.org, eliezer@tamir.org.il
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com> <20130709162514.062f1361@lwn.net> <20130709.160611.636749585237773459.davem@davemloft.net>
In-Reply-To: <20130709.160611.636749585237773459.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 02:06, David Miller wrote:
> From: Jonathan Corbet <corbet@lwn.net>
> Date: Tue, 9 Jul 2013 16:25:14 -0600
> 
>> On Mon, 08 Jul 2013 16:20:34 +0300
>> Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
>>
>>> Rename POLL_LL to POLL_BUSY_LOOP.
>>
>> So pardon me if I speak out of turn, but it occurs to me to
>> wonder...should the SO_LL socket option be renamed in a similar fashion
>> before this interface escapes into the wild?
> 
> Sure and we can rename include/net/ll_poll.h to something more
> fitting as well.
> 
> I'll make sure this happens before 3.11 gets even close to release.

David,

If the following names changes are acceptable I will try to send out
a patch today.

1. include/net/ll_poll.h -> include/net/busy_poll.h

2. ndo_ll_poll -> ndo_busy_poll

- not technically accurate since the ndo callback does not itself busy
poll, it's just used to implement it.

maybe ndo_napi_id_poll? or ndo_id_poll? I don't really like any of them,
so a suggestion would be nice.

3. sysctl_net_ll_{read,poll} -> sysctl_net_busy_{read,poll}
- along with matching file name changes.

4. {sk,skb}_mark_ll -> {sk,skb}_mark_napi_id

5. LL_SO -> BUSY_POLL_SO

Are you OK with the names?
Did I miss anything?

Thanks,
Eliezer
