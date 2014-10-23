Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaJWKhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:37:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:59317 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752216AbaJWKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:37:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,774,1406563200"; 
   d="scan'208";a="37818026"
Message-ID: <5448DB05.5050803@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 18:40:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ingo Molnar <mingo@kernel.org>, <torvalds@linux-foundation.org>,
        <paulmck@linux.vnet.ibm.com>, <tglx@linutronix.de>,
        <akpm@linux-foundation.org>, <riel@redhat.com>, <mgorman@suse.de>,
        <oleg@redhat.com>, <mingo@redhat.com>, <minchan@kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <viro@zeniv.linux.org.uk>,
        <dave@stgolabs.net>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
References: <20141020215633.717315139@infradead.org> <20141021162340.GA5508@gmail.com> <20141021170948.GA25964@node.dhcp.inet.fi> <20141021175603.GI3219@twins.programming.kicks-ass.net>
In-Reply-To: <20141021175603.GI3219@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 01:56 AM, Peter Zijlstra wrote:
> On Tue, Oct 21, 2014 at 08:09:48PM +0300, Kirill A. Shutemov wrote:
>> It would be interesting to see if the patchset affects non-condended case.
>> Like a one-threaded workload.
> 
> It does, and not in a good way, I'll have to look at that... :/

Maybe it is blamed to find_vma_srcu() that it doesn't take the advantage of
the vmacache_find() and cause more cache-misses.


Is it hard to use the vmacache in the find_vma_srcu()?

> 
>  Performance counter stats for './multi-fault 1' (5 runs):
> 
>         73,860,251      page-faults                                                   ( +-  0.28% )
>             40,914      cache-misses                                                  ( +- 41.26% )
> 
>       60.001484913 seconds time elapsed                                          ( +-  0.00% )
> 
> 
>  Performance counter stats for './multi-fault 1' (5 runs):
> 
>         70,700,838      page-faults                                                   ( +-  0.03% )
>             31,466      cache-misses                                                  ( +-  8.62% )
> 
>       60.001753906 seconds time elapsed                                          ( +-  0.00% )
> .
> 

