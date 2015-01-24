Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbbAXBCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:02:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23405 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbAXBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:02:42 -0500
Message-ID: <54C2EF09.3090407@oracle.com>
Date: Fri, 23 Jan 2015 20:02:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: WANG Chao <chaowang@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>
CC: Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, vmacache: Add kconfig VMACACHE_SHIFT
References: <1421908189-18938-1-git-send-email-chaowang@redhat.com> <1421912761.4903.22.camel@stgolabs.net> <20150122075742.GA11335@dhcp-129-179.nay.redhat.com> <1421943573.4903.24.camel@stgolabs.net> <54C123CF.2070107@redhat.com> <20150123051422.GC8670@dhcp-129-179.nay.redhat.com>
In-Reply-To: <20150123051422.GC8670@dhcp-129-179.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:14 AM, WANG Chao wrote:
> On 01/22/15 at 11:22am, Rik van Riel wrote:
>> > On 01/22/2015 11:19 AM, Davidlohr Bueso wrote:
>>> > > On Thu, 2015-01-22 at 15:57 +0800, WANG Chao wrote:
>>>> > >> Hi, Davidlohr
>>>> > >>
>>>> > >> On 01/21/15 at 11:46pm, Davidlohr Bueso wrote:
>>>>> > >>> On Thu, 2015-01-22 at 14:29 +0800, WANG Chao wrote:
>>>>>> > >>>> Add a new kconfig option VMACACHE_SHIFT (as a power of 2) to specify the
>>>>>> > >>>> number of slots vma cache has for each thread. Range is chosen 0-4 (1-16
>>>>>> > >>>> slots) to consider both overhead and performance penalty. Default is 2
>>>>>> > >>>> (4 slots) as it originally is, which provides good enough balance.
>>>>>> > >>>>
>>>>> > >>>
>>>>> > >>> Nack. I don't feel comfortable making scalability features of core code
>>>>> > >>> configurable.
>>>> > >>
>>>> > >> Out of respect, is this a general rule not making scalability features
>>>> > >> of core code configurable?
>>> > > 
>>> > > I doubt its a rule, just common sense. Users have no business
>>> > > configuring such low level details. The optimizations need to
>>> > > transparently work for everyone.
>> > 
>> > There may sometimes be a good reason for making this kind of
>> > thing configurable, but since there were no performance
>> > numbers in the changelog, I have not seen any such reason for
>> > this particular change :)
> True. I didn't run any kind of benchmark, thus no numbers here. This is
> purely hypothetical.
> 
> I'm glad to run some tests. For the sake of consistency, could you
> please show me a hint how do you measure at the first place? I can do
> hit-rate, but I don't know how you measure cpu cycles. Could you
> elaborate?

I don't think there's a need to look for problems where there are none.

Have you observed a performance issue that might be improved by changing
the shift here?


Thanks,
Sasha
