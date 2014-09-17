Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbaIQVif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:38:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41461 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbaIQVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:38:34 -0400
Message-ID: <5419FF2F.4000705@oracle.com>
Date: Wed, 17 Sep 2014 17:37:51 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de> <540F7D42.1020402@oracle.com> <alpine.LSU.2.11.1409091903390.10989@eggly.anvils> <20140910124732.GT17501@suse.de> <alpine.LSU.2.11.1409101210520.1744@eggly.anvils> <54110C62.4030702@oracle.com> <alpine.LSU.2.11.1409110356280.2116@eggly.anvils> <20140911162827.GZ17501@suse.de> <5412246E.109@oracle.com>
In-Reply-To: <5412246E.109@oracle.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 06:38 PM, Sasha Levin wrote:
> On 09/11/2014 12:28 PM, Mel Gorman wrote:
>> > Agreed. If 3.17-rc4 looks stable with the VM_BUG_ON then it would be
>> > really nice if you could bisect 3.17-rc4 to linux-next carrying the
>> > VM_BUG_ON(!(val & _PAGE_PRESENT)) check at each bisection point. I'm not
>> > 100% sure if I'm seeing the same corruption as you or some other issue and
>> > do not want to conflate numerous different problems into one. I know this
>> > is a pain in the ass but if 3.17-rc4 looks stable then a bisection might
>> > be faster overall than my constant head scratching :(
> The good news are that 3.17-rc4 seems to be stable. I'll start the bisection,
> which I suspect would take several days. I'll update when I run into something.

I might need a bit of a help here. The bisection is going sideways because I
can't reliably reproduce the issue.

We don't know what's causing this issue, but we know what the symptoms are. Is
there a VM_BUG_ON we could add somewhere so that it would be more likely to
trigger?


Thanks,
Sasha
